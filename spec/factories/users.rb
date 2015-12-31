require 'faker'

FactoryGirl.define do
  factory :user do
    email "kevin_du+94@hotmail.com"
    firstname { Faker::Name.first_name }
    lastname { Faker::Name.last_name }
    hruid { firstname.downcase.gsub(/[^a-z ]/, '')+'.'+lastname.downcase.gsub(/[^a-z ]/, '')+"."+["1950","2015","ext","soce","associe"].sample+["",".2",".3"].sample}
    password Devise.friendly_token[0,20]

	  factory :admin do   
	    	role FactoryGirl.create(:role, name:"admin")
	  end
  end

end
