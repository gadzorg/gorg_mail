class SetupSubscriptionService
  attr_reader :user, :mailing_lists

  def initialize(user)
    @user = user
    @mailing_lists = {}

    build_mailing_lists
  end

  def do_subscribe
    mailing_lists.each do |ml_key, mailing_list|
      service = MailingListSubscriptionService.new(list: mailing_list, user: user)
      service.do_subscribe
    end
  end

  [:proms, :tabagns, :info].each do |prefix|
    define_method "#{prefix}_mailing_list" do
      mailing_lists[prefix]
    end
  end

  private

  def build_mailing_lists
    add_mailing_list :proms, proms_mailing_list_email
    add_mailing_list :tabagns, tabagns_mailing_list_email
    add_mailing_list :info, info_mailing_list_email
  end

  def add_mailing_list(ml_key, email)
    ml = Ml::List.find_by(email: email)
    @mailing_lists[ml_key] = ml if ml
  end

  # La mailing list de Promotion
  # Exemple : bordeaux + 2017 => bo217@gadz.org
  def proms_mailing_list_email
    "#{gadz_tabagns}#{gadz_ans}@gadz.org"
  end

  # La mailing list du Tabagn’s
  # Exemple : bordeaux => tbk.bo@gadz.org, aix => tbk.kin@gadz.org
  def tabagns_mailing_list_email
    "tbk.#{gadz_tabagns}@gadz.org"
  end

  # La mailing list d’information
  def info_mailing_list_email
    "info-pg@gadz.org"
  end

  # User "Tabagn's"
  # ex: an, bo, ch, cl, ka, li, me, kin (ai)
  # Note: exception for Aix(ai) : kin
  def gadz_tabagns
    case user.gadz_centre_principal
      when 'ai' then 'kin'
      else user.gadz_centre_principal
    end
  end
  
  # User "an's"
  # ex: "1998"->"198" , "2017"->"217"
  # Note: expected year >= 1947 
  def gadz_ans
    (user.gadz_proms_principale.to_i - 1800).to_s
  end
end