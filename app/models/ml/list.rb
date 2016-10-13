# == Schema Information
#
# Table name: ml_lists
#
#  id                                     :integer          not null, primary key
#  name                                   :string
#  email                                  :string
#  description                            :string
#  aliases                                :string
#  diffusion_policy                       :string
#  messsage_header                        :string
#  message_footer                         :string
#  is_archived                            :boolean
#  custom_reply_to                        :string
#  default_message_deny_notification_text :string
#  msg_welcome                            :string
#  msg_goodbye                            :string
#  message_max_bytes_size                 :integer
#  created_at                             :datetime         not null
#  updated_at                             :datetime         not null
#  inscription_policy                     :string
#  group_uuid                             :string
#
# Indexes
#
#  index_ml_lists_on_email       (email)
#  index_ml_lists_on_group_uuid  (group_uuid)
#

class Ml::List < ActiveRecord::Base
  # keep this function before validation
  def self.inscription_policy_list
    %w(open conditional_gadz closed in_group)
  end

  validates :name, presence: true #, uniqueness: true
  validates :email, uniqueness: true, presence: true, format: { with: /\A([^@+_\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}
  # validates :diffusion_policy, presence: true, acceptance: { accept: %w(open closed moderated) }
  validates_inclusion_of :diffusion_policy, :in => %w(open closed moderated)
  validates_inclusion_of :inscription_policy, :in => Ml::List.inscription_policy_list
  validates_inclusion_of :is_archived, :in => [true, false]
  validates :message_max_bytes_size, presence: true
  after_save :sync_with_mailing_list_service
  after_create {Alias.new_for_mailinglist(self)}
  after_destroy :delete_with_mailing_list_service

  has_and_belongs_to_many :users
  has_many :ml_external_emails, :class_name => 'Ml::ExternalEmail', :dependent => :destroy
  has_many :redirection_aliases,  :class_name => 'Alias'

  def add_user_no_sync(user)
    self.users.where(users: {id: user.id}).blank? ? self.users << user : errors.add(:user, "User already in list")
  end

  def remove_user_no_sync(user)
    self.users.delete(user)
  end

  def add_user(user)
    add_user_no_sync(user)
    if sync_with_mailing_list_service
      return true
    else
      remove_user_no_sync(user)
      logger.fatal "Unable to sync with mailing list service -- Possible connexion issue with rabbitMQ"
      return false
    end
  end

  def remove_user(user)
    remove_user_no_sync(user)
    if sync_with_mailing_list_service
      return true
    else
      add_user_no_sync(user)
      logger.fatal "Unable to sync with mailing list service -- Possible connexion issue with rabbitMQ"
      return false
    end
  end

  def allow_access_to(user)
    return true if self.is_public
    # group only
  end

  def belong_to_group?
    self.group_uuid.present?
  end

  def group
    self.belong_to_group? ?  GramV2Client::Group.find(self.group_uuid) : nil
  end

  def self.all_if_open
    Ml::List.where(inscription_policy: "open")
  end

  def all_emails
    members_emails = self.users.includes(email_source_accounts: :email_virtual_domain).where(email_source_accounts: {primary: true}).pluck(:"CONCAT(email_source_accounts.email, '@' ,email_virtual_domains.name)") #Take all primary email of user. More perf than user.primary
    external_emails = self.ml_external_emails.pluck(:email)
    members_emails + external_emails
  end

  def members_count
    cache_name = "a#{self.email}-#{self.updated_at.to_i}-list_member_count"
    Rails.cache.fetch(cache_name, expires_in: 10.minute) do
      self.users.count + self.ml_external_emails.count
    end
  end

  # Return an array of array [ id_user, full_name, primary_email]
  def members_list_with_emails
    self.users.includes(email_source_accounts: :email_virtual_domain).where(email_source_accounts: {primary: true}).order(:firstname).pluck("users.id", :"CONCAT(users.firstname, ' ', users.lastname)", :"CONCAT(email_source_accounts.email, '@' ,email_virtual_domains.name)")
  end

  ############# external emails #############
  def add_email(email_address,sync = true)
    era = EmailRedirectAccount.includes(:user).find_by(redirect: email_address)
    esa = EmailSourceAccount.includes(:user).find_by_full_email(email_address) if era.nil?

    if era.present?
      logger.debug "ERA!"
      add_user_no_sync(era.user)
    elsif esa.present?
      logger.debug "ESA!"
      add_user_no_sync(esa.user)
    else
      logger.debug "External!"
      Ml::ExternalEmail.create(email: email_address, list_id: self.id)
    end
    sync_with_mailing_list_service if sync == true
  end

  def remove_email(email_external)
    email_external.destroy
    sync_with_mailing_list_service
  end

  # send notification to update ML in Ml service
  def sync_with_mailing_list_service
    MailingListsService.new(self).update
  end

  def delete_with_mailing_list_service
    MailingListsService.new(self).delete
  end


  ################# email_alias ################

  def redirection_alias_old
    Alias.find_by(redirect: self.email.gsub(Configurable[:main_mail_domain],Configurable[:default_google_apps_domain_alias]))
  end

  def redirection_alias
    self.redirection_aliases.take
  end

  def self.fix_aliases_association
    Ml::List.all.each do |l|
      redir_alias = l.redirection_alias_old
      l.redirection_aliases << redir_alias
    end
  end


end
