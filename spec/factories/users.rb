require 'faker'

FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    firstname { Faker::Name.first_name }
    lastname { Faker::Name.last_name }
    hruid { firstname.downcase.gsub(/[^a-z ]/, '')+'.'+lastname.downcase.gsub(/[^a-z ]/, '')+"."+["1950","2015","ext","soce","associe"].sample+["",".2",".3"].sample}
    password Devise.friendly_token[0,20]
    password_confirmation {password}

	  factory :admin do   
	    	role {FactoryGirl.create(:role, name:"admin")}
        email "admin@poubs.org"
	  end

    factory :invalid_user do
      email nil
    end

  end
end
