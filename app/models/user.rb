class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:GadzOrg]

  def update_from_gram
  	gram_data=GramAccount.find(self.hruid)

  	self.email=gram_data.email
  	self.firstname=gram_data.firstname
    self.lastname=gram_data.lastname
  end

  def self.omniauth(auth_data, signed_in_resource=nil)
    
    logger.info "=================================="
    logger.info "Connexion depuis le CAS uid : "+auth_data[:uid]
    logger.info "Infos de connection !"
    logger.info auth_data.inspect


    # auth_data : take a look on Users::OmniauthCallbacksController
    until user = User.find_by_hruid(auth_data[:uid])
      user = User.new(
        email: auth_data[:info][:email],
        password: Devise.friendly_token[0,20],
        hruid: auth_data[:uid],
        firstname: auth_data[:extra][:firstname],
        lastname: auth_data[:extra][:lastname],
      )
      user.save!
    end

    user.update_from_gram

    return user
  end

end
