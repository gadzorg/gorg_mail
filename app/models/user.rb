# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default("")
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  hruid                  :string(255)      not null
#  firstname              :string(255)
#  lastname               :string(255)
#  role_id                :integer
#  last_gram_sync_at      :datetime
#  canonical_name         :string(255)
#  uuid                   :string(255)
#  is_gadz                :boolean
#
# Indexes
#
#  index_users_on_canonical_name        (canonical_name)
#  index_users_on_hruid                 (hruid) UNIQUE
#  index_users_on_is_gadz               (is_gadz)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_role_id               (role_id)
#  index_users_on_uuid                  (uuid) UNIQUE
#

# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_role_id               (role_id)
#


##
# A User of the application
#
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :rememberable, :trackable,
         :omniauthable, :omniauth_providers => [:GadzOrg]

  ##
  # synced_with_gram : True if last sync with gram data succeed (false if not).
  # false if object never tried to sync at runtime. Auto sync performed at connection via CAS
  attr_accessor :synced_with_gram

  # Associations
  belongs_to :role
  has_and_belongs_to_many :ml_lists, :class_name => 'Ml::List'
  has_many :email_redirect_accounts, dependent: :destroy
  has_many :email_source_accounts, dependent: :destroy


  after_initialize :set_default_values
  #TODO : switch to GrAM Canonical name
  after_create :create_canonical_name


  validates :hruid, uniqueness: true, :allow_blank => true, :allow_nil => false




############################################################################
#######  TEMPLATE FUNCTIONS  ###############################################
############################################################################
  ##
  # Check current role
  def has_role? (role_name)
    self.role ? self.role.name==(role_name.to_s) : false
  end


  ##
  # Add or change role
  def  add_role (role_name)
    self.update_attribute(:role_id,Role.find_or_create_by(name: role_name).id)
  end

  ##
  # Delete current role if any
  def  remove_role (role_name=nil)
    self.update_attribute(:role_id,nil) unless !self.role ||(role_name && role_name.to_s != self.role.name)
  end

  ##
  # Update local user data with data contained in GrAM
  def update_from_gram
    self.synced_with_gram = false
    if self.syncable?
      begin
        gram_data= GramV2Client::Account.find(self.uuid)
        self.email=gram_data.email
        self.firstname=gram_data.firstname
        self.lastname=gram_data.lastname
        self.last_gram_sync_at = Time.now
        self.hruid = gram_data.hruid
        self.is_gadz = gram_data.is_gadz
        if self.save
          self.synced_with_gram = true 
          return self
        else
          return false
        end
      rescue ActiveResource::ResourceNotFound
        logger.error "[GrAM] Utilisateur introuvable : hruid = #{self.hruid} uuid = #{self.uuid}"
        return false
      rescue ActiveResource::ServerError
        logger.error "[GrAM] Connexion au serveur impossible"
        return false
      rescue ActiveResource::UnauthorizedAccess, ActiveResource::ForbiddenAccess
        logger.error "[GrAM] Connexion au serveur impossible : verifier identifiants"
        return false
      end
    else
      return false
    end

  end

  def syncable?
    uuid.present?
  end

  def next_sync_allowed_at
    self.last_gram_sync_at ? self.last_gram_sync_at + 5.minutes : Time.now
  end

  ##
  # Return an User to login after Omniauth authentification. This user is retrieve in database with hruid or
  # created on the fly from CAS data
  def self.omniauth(auth_data, signed_in_resource=nil)

    logger.debug "=================================="
    logger.debug "Connexion depuis le CAS uid : "+auth_data[:uid]
    logger.debug "Infos de connection :"
    logger.debug auth_data.inspect

    # auth_data : take a look on Users::OmniauthCallbacksController
    unless user = User.find_by_uuid(auth_data[:extra][:uuid])
      user = User.new(
          email: auth_data[:info][:email],
          password: Devise.friendly_token[0,20],
          hruid: auth_data[:uid],
          firstname: auth_data[:extra][:firstname],
          lastname: auth_data[:extra][:lastname],
          uuid: auth_data[:extra][:uuid],
      )
      user.save
    end

    if user.persisted?
      user.update_from_gram
      user
    else
      logger.error "Donnees renvoyes par le CAS invalide : "+auth_data.to_s+" ---- "+user.errors.messages.inspect
      nil
    end
  end

  ##
  # Return user firstname and lastname
  def fullname
    firstname + " " + lastname
  end

  ############################################################################
  #######  FORK FUNCTIONS  ###################################################
  ############################################################################

  def has_google_apps
    email_redirect_accounts.select(&:persisted?).any?{|era| era.type_redir=="googleapps"}
  end

  def google_apps
    email_redirect_accounts.find_by( type_redir: "googleapps")
  end

=begin
  def create_google_apps
    #check if canonical name exist
    unless self.canonical_name.nil?
      # check if google apps exist via GAM ( possible?) TODO
      # if gadz => gadz.fr TODO 
      # else => agoram.org ( or other) TODO
      google_apps_adress = self.canonical_name + "@gadz.fr"
      #create gogogleapps via GAM TODO
      #create redirection

      self.email_redirect_accounts.new( 
        redirect: google_apps_adress,
        type_redir: "googleapps"
        )
      self.save
    end
    
  end
=end

  # Create google apps account and redirection via google apps service
  def create_google_apps
    GoogleApps.new(self).generate
  end

  def create_canonical_name()
    self.canonical_name = self.generate_canonical_name()
    self.save
  end    

  def generate_canonical_name()
    #TODO
    #il faut passer les nom et prenom en minuscule
    firstname_p = self.firstname.downcase
    lastname_p = self.lastname.downcase

    firstname_p = format_name(firstname_p)
    lastname_p = format_name(lastname_p)

    #definir le nom canonique standard
    default_canonical_name = firstname_p + "." + lastname_p
    # vérifier si il est déjà dans la base
    
    canonical_name = default_canonical_name # on définit une première fois le nom canonique qui "peut" être le bon

    if !User.find_by(canonical_name: canonical_name).nil?
      #si oui ajouter la promo TODO
      default_canonical_name = hruid
      # vérifier si elle est déjà dans la base

      canonical_name = default_canonical_name

      i=0
      
      while !User.find_by(canonical_name: canonical_name).nil?
        i+=1
        canonical_name = default_canonical_name + "." + i.to_s  
      end
      # si oui, ajouter un .2 et boucler .3, .4 etc.
      
    end

    return canonical_name #attetion TEST UNIQUEMENT
      
  end


  # reformatage des noms
  def format_name(name)
    require "i18n"
    #remplacement des espaces et apostrophes par des "-"
    name = name.gsub(" ", "-")
    name = name.gsub("'", "-")
    name = name.gsub("’", "-")
    name = name.gsub("`", "-")

    # suppression des accents
    name = I18n.transliterate(name)
    return name
  end

  def primary_email
    self.email_source_accounts.find_by(primary: true)
  end

  def is_gadz?
    self.update_attribute( :is_gadz, GramV2Client::Account.find(self.uuid).is_gadz)
    self.is_gadz
  end

  def is_gadz_cached?
    self.is_gadz
  end

  def groups
    begin
      GramV2Client::Account.find(self.uuid).groups
    #TODO : move this dirty hack to gem
    rescue => error
      if error.to_s.include?("Response code = 404")
        return []
      else
        # This is very bad.
        puts error
        return []
      end
    end
  end

  def lists_allowed_not_joined
    lists_allowed - self.ml_lists
  end

  def lists_allowed(from_cache=false)
    cache_name = "a#{self.uuid}-#{self.updated_at.to_i}-lists_allowed"
    puts cache_name
    Rails.cache.delete(cache_name) if from_cache == false
    Rails.cache.fetch(cache_name, expires_in: 10.minute) do
      lists_allowed_for_this_user = Ml::List.all_if_open
      user_groups_uuid = self.groups.map(&:uuid)
      lists_allowed_for_this_user = lists_allowed_for_this_user + Ml::List.where(inscription_policy: "conditional_gadz")
      user_groups_uuid.each do |guuid|
        lists_allowed_for_this_user << Ml::List.find_by(group_uuid: guuid)
      end
      lists_allowed_for_this_user.compact.uniq
    end
  end

  private

    ############################################################################
    #######  TEMPLATE FUNCTIONS  ###############################################
    ############################################################################

    ##
    #Define default values of runtime attributes
    def set_default_values
      self.synced_with_gram = false
    end


    ############################################################################
    #######  FORK FUNCTIONS  ###################################################
    ############################################################################

end
