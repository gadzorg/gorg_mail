class EmailFinder

  def initialize(email,opts={})
    @email=email
    @klasses_search_order=opts.fetch(:priority_array,[EmailSourceAccount,EmailRedirectAccount,User,Ml::ExternalEmail])
  end

  def find_one
    target=nil
    @klasses_search_order.detect do |k|
      target=k.find_email(@email)
    end
    target
  end

  def find_all
    objects=@klasses_search_order.map do |k|
      k.find_all_email(@email)
    end
    objects.flatten
  end


end