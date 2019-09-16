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
#  gadz_centre_principal  :string(255)
#  gadz_proms_principale  :string(255)
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
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :rememberable, :trackable, :masqueradable,
         :omniauthable, :omniauth_providers => [:GadzOrg]

  include TokenableConcern

  ##
  # synced_with_gram : True if last sync with gram data succeed (false if not).
  # false if object never tried to sync at runtime. Auto sync performed at connection via CAS
  attr_accessor :synced_with_gram

  # Associations
  belongs_to :role, optional: true

  has_many :email_redirect_accounts, dependent: :destroy
  has_many :email_source_accounts, dependent: :destroy
  has_one :primary_source_accounts, -> { where(primary: true) }, class_name: "EmailSourceAccount", dependent: :destroy

  after_initialize :set_default_values
  #TODO : switch to GrAM Canonical name
  after_create :create_canonical_name

  validates :hruid, uniqueness: true, presence: true

  ## Ml::Lists
  has_many :ml_lists_users, :class_name => 'Ml::ListsUser', dependent: :delete_all
  has_many :lists, through: :ml_lists_users, :class_name => 'Ml::List'
  alias_method :ml_lists, :lists

  (Ml::ListsUser.roles.keys.map(&:pluralize)+["all_members", "super_members"]).each do |role_name|
    has_many "ml_lists_users_#{role_name}".to_sym, -> { send(role_name) }, :class_name => "Ml::ListsUser"
    has_many "lists_#{role_name}".to_sym, through: "ml_lists_users_#{role_name}".to_sym, :class_name => "Ml::List", :source => :list
    alias_method "ml_lists_#{role_name}".to_sym, "lists_#{role_name}".to_sym
  end

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
  #
  # https://github.com/gadzorg/gram2_api_server/blob/master/db/schema.rb
  #
  # gram_data= GramV2Client::Account.find(self.uuid)
  #
  # {
  #   "uuid"=>"5fa5d1e2-bc24-47d4-922b-86d5c9376b66",
  #   "hruid"=>"john.doe1.2017",
  #   "id_soce"=>311037,
  #   "enabled"=>true,
  #   "lastname"=>"Doe ",
  #   "firstname"=>"John",
  #   "birthname"=>"Doe ",
  #   "birth_firstname"=>"",
  #   "email"=>"john.doe1@test.fr",
  #   "gapps_id"=>"",
  #   "birthdate"=>"1997-01-01",
  #   "deathdate"=>"",
  #   "gender"=>"male",
  #   "is_gadz"=>true,
  #   "is_student"=>false,
  #   "school_id"=>"", # ----- NUMERO IDENTIFIANT ELEVE ENSAM
  #   "is_alumni"=>false,
  #   "date_entree_ecole"=>"",
  #   "date_sortie_ecole"=>"1900-01-01",
  #   "ecole_entree"=>"",
  #   "buque_texte"=>"",
  #   "buque_zaloeil"=>"",
  #   "gadz_fams"=>"",
  #   "gadz_fams_zaloeil"=>"",
  #   "gadz_proms_principale"=>"2017",
  #   "gadz_proms_secondaire"=>"0",
  #   "avatar_url"=>"",
  #   "description"=>"",
  #   "audit_status"=>"safe",
  #   "audit_comments"=>nil,
  #   "is_from_legacy_gram1"=>nil,
  #   "gadz_centre_principal"=>"bo",
  #   "gadz_centre_secondaire"=>nil,
  #   "url"=>"/api/v2/accounts/5fa5d1e2-bc24-47d4-922b-86d5c9376b66",
  #   "aliases"=>[],
  #   "groups"=>[],
  #   "roles"=>[]
  # }
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
        # use try to prevent from issue if GorgMail is released before GrAM
        self.gadz_proms_principale = gram_data.try(:gadz_proms_principale) # ex: "2017"
        self.gadz_centre_principal = gram_data.try(:gadz_centre_principal) # ex: "bo"

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
  #
  # Example auth_data:
  #
  #   credentials=#<OmniAuth::AuthHash ticket="ST-207-3OmkDkC91b1W3wYgbnx2-cas">
  #   extra=#<OmniAuth::AuthHash
  #     firstname="John"
  #     lastname="Doe "
  #     soce_id="311037"
  #     user="john.doe1.2017"
  #     username="john.doe1.2017"
  #     uuid="5fa5d1e2-bc24-47d4-922b-86d5c9376b66"
  #   >
  #   info=#<OmniAuth::AuthHash::InfoHash email="john.doe1@test.fr">
  #   provider="GadzOrg"
  #   uid="john.doe1.2017"
  #
  # Note auth_data does not include 'centre' neither 'allproms' in latest CAS version
  #
  #   auth_data[:extra] "centre"=>"CER de Metz",   # tabagns
  #   auth_data[:extra] "allproms"=>"81-21.me208", # proms
  #
  def self.omniauth(auth_data, signed_in_resource=nil)

    logger.debug "=================================="
    logger.debug "Connexion depuis le CAS uid : "+auth_data[:uid]
    logger.debug "Infos de connection :"
    logger.debug auth_data.inspect

    return nil unless auth_data[:extra][:uuid]

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

  def self.find_by_id_or_hruid_or_uuid(id)
    where("CAST(id AS CHAR)=:id OR uuid=:id OR hruid=:id",id: id).take
  end

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

  def contact_email
    self.primary_email ? self.primary_email.to_s : self.email
  end

  def is_gadz?
    self.update_attribute( :is_gadz, GramV2Client::Account.find(self.uuid).is_gadz)
    self.is_gadz
  end

  def is_gadz_cached?
    self.is_gadz
  end

  def groups
    GramV2Client::Account.find(self.uuid).groups
  rescue GramV2Client::ResourceNotFound
    []
  rescue StandardError => error
    # This is very bad.
    Rails.logger.error error
    []
  end

  ################ lists  ###############
  def lists_allowed_not_joined
  lists_allowed.where.not(id: self.ml_lists.pluck(:id))
  end

  def lists_allowed(from_cache=false)
  cache_name = "a#{self.uuid}-#{self.updated_at.to_i}-lists_allowed"
    Rails.logger.debug cache_name
    Rails.cache.delete(cache_name) if from_cache == false
    Rails.cache.fetch(cache_name, expires_in: 10.minute) do
      user_groups_uuid = self.groups.map(&:uuid)
      conditions = "inscription_policy IN ('open')"
      conditions += "OR inscription_policy IN ('conditional_gadz')" if self.is_gadz_cached?
      conditions += " OR group_uuid IN (#{user_groups_uuid.map{|e|"\"#{e}\""}.join(",")})" if user_groups_uuid.any?
      Ml::List.includes(redirection_aliases: :email_virtual_domain).where(conditions)
    end
  end

  def self.basic_data_hash
    # Arel is required since Rails 5 because of SQL functions in pluck (CONCAT)
    arel_fullname =
      Arel::Nodes::NamedFunction.new(
        "concat",
        [
          User.arel_table[:firstname],
          Arel::Nodes.build_quoted(" "),
          User.arel_table[:lastname],
        ],

      )

    primary_source_table = EmailSourceAccount.arel_table.alias("primary_source_accounts")
    virtual_domain_table = EmailVirtualDomain.arel_table

    arel_email =
      Arel::Nodes::NamedFunction.new(
        "concat",
        [
          primary_source_table[:email],
          Arel::Nodes.build_quoted("@"),
          virtual_domain_table[:name],
        ],
      )

    includes(:ml_lists_users).joins(
      arel_table.join(
        primary_source_table, Arel::Nodes::OuterJoin
      ).on(
        primary_source_table[:user_id].eq(arel_table[:id]).and(primary_source_table[:primary].eq(true))
      ).join_sources
    ).joins(
      arel_table.join(
        virtual_domain_table, Arel::Nodes::OuterJoin
      ).on(
        virtual_domain_table[:id].eq(primary_source_table[:email_virtual_domain_id])
      ).join_sources
    ).reorder(arel_fullname) # override default order which can be set by a relation which would fail the query
     .pluck(
      "DISTINCT users.id", arel_fullname, arel_email, "ml_lists_users.role", "users.email",
    ).map do |arr|
      {
        id: arr[0],
        name: arr[1],
        email: arr[2],
        role: arr[3],
        account_email: arr[4],
      }
    end
  end


  def self.search(query)
    sql_query =
      if query.present?
        <<~END_SQL
          LOWER(CONCAT(email_source_accounts.email, '@' ,email_virtual_domains.name)) LIKE :like_query
            OR LOWER(users.firstname) LIKE :like_query
            OR LOWER(users.lastname) LIKE :like_query
            OR LOWER(CONCAT(users.firstname,' ',users.lastname)) LIKE :like_query
            OR LOWER(users.hruid) LIKE :like_query
            OR LOWER(users.uuid) = :query
            OR LOWER(email_redirect_accounts.redirect) = :query
        END_SQL
      end

    arel = Arel::Nodes::SqlLiteral.new(sql_query.presence || "")

    includes(email_source_accounts: :email_virtual_domain) \
      .includes(:email_redirect_accounts) \
      .where(
        arel,
        query: query.to_s.downcase,
        like_query: "%#{query.to_s.downcase}%",
      ).references(
        email_source_accounts: :email_virtual_domain,
        email_redirect_account: true,
      )
  end

  ################ lists role ###############

  def get_role_in_list(list_id)
    self.ml_lists_users.find_by(list_id: list_id).role
  end

  def self.primary_emails
    # Take all primary email of user. More perf than user.primary
    includes(email_source_accounts: :email_virtual_domain) \
      .where(email_source_accounts: { primary: true }) \
      .pluck(primary_email_concat)
  end

  # @return [String]
  def self.contact_emails
    # Take all primary email of user. More perf than user.primary
    email_not_null = Arel::Nodes::NotEqual.new(EmailSourceAccount.arel_table["email"], nil)

    arel =
      Arel::Nodes::NamedFunction.new(
        "if",
        [email_not_null, primary_email_concat, arel_table["email"]],
      )

    includes(primary_source_accounts: :email_virtual_domain).pluck(arel)
  end

  def self.primary_email_concat
    arobase = Arel::Nodes.build_quoted("@")

    args = [
      EmailSourceAccount.arel_table["email"],
      arobase,
      EmailVirtualDomain.arel_table["name"],
    ]

    Arel::Nodes::NamedFunction.new("concat", args)
  end

  def self.find_email(email)
    self.find_by(email: email)
  end

  def self.find_all_email(email)
    self.where(email: email)
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
