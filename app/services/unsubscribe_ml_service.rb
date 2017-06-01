class UnsubscribeMlService

  TOKEN_SCOPE='confirm_unsubscribe_address'

  def initialize(email: nil, token: nil)
    @email = email
    @token = token
  end

  def send_email_confirmation
    UnsubscribeMailer.confirm_email(@email,self.token.token).deliver_now
  end

  def token
    @token||=Token.create(scope: TOKEN_SCOPE, data:{email: @email})
  end

  def linked_objects
    @linked_objects||=EmailFinder.new(@email).find_all
  end

  def mailling_lists_map
    linked_objects.map{|o|[o,retrieve_mls_for(o)]}.to_h
  end

  def mailling_lists
    mailling_lists_map.values.flatten.uniq
  end

  def self.initialize_from_email(email)
    self.new(email: email)
  end

  def self.initialize_from_token(token)
    self.new(email:token.data[:email], token: token)
  end

  def perform_unsubscribe(hash)
    mlm=mailling_lists_map
    mlm.each do |obj,v|
      v.each do |ml|
        perform_unsub_for(obj,ml) if hash[ml.name]
      end
    end

    @token.set_used
  end

  def has_an_account?
    linked_objects.any?{|o| [User, EmailSourceAccount,EmailRedirectAccount].any?{|k| o.is_a? k}}
  end

  private

  def retrieve_mls_for(obj)
    case obj
      when User
        obj.lists_all_members
      when EmailSourceAccount
        retrieve_mls_for(obj.user)
      when EmailRedirectAccount
        retrieve_mls_for(obj.user)
      when Ml::ExternalEmail
        [obj.ml_list]
      else
        []
    end
  end

  def perform_unsub_for(obj,ml)
    case obj
      when User
        ml.remove_user(obj)
      when EmailSourceAccount
        perform_unsub_for(obj.user,ml)
      when EmailRedirectAccount
        perform_unsub_for(obj.user,ml)
      when Ml::ExternalEmail
        ml.remove_email(obj)
      else
        nil
    end
  end
end