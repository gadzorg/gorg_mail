# == Schema Information
#
# Table name: ml_lists
#
#  id                                     :integer          not null, primary key
#  name                                   :string(255)
#  email                                  :string(255)
#  description                            :string(255)
#  aliases                                :string(255)
#  diffusion_policy                       :string(255)
#  messsage_header                        :string(255)
#  message_footer                         :string(255)
#  is_archived                            :boolean
#  custom_reply_to                        :string(255)
#  default_message_deny_notification_text :string(255)
#  msg_welcome                            :string(255)
#  msg_goodbye                            :string(255)
#  message_max_bytes_size                 :integer
#  created_at                             :datetime         not null
#  updated_at                             :datetime         not null
#  inscription_policy                     :string(255)
#  group_uuid                             :string(255)
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
  after_create {Alias.new_for_mailinglist(self)}
  after_save :sync_with_mailing_list_service
  after_destroy {|record|delete_with_mailing_list_service(record)}

  has_many :ml_external_emails, :class_name => 'Ml::ExternalEmail', :dependent => :destroy
  has_many :redirection_aliases,  :class_name => 'Alias'

  has_many :lists_users, :class_name => "Ml::ListsUser"
  has_many :users, through: :lists_users

  # set associations for roles
  # Create :
  #
  # lists_users_banneds
  # banneds (liste des users)
  # lists_users_moderators
  # moderators (liste des users)
  # ...
  #
  (Ml::ListsUser.roles.keys.map(&:pluralize)+["all_members","super_members"]).each do |role_name|
    has_many "lists_users_#{role_name}".to_sym, -> { send(role_name) }, :class_name => "Ml::ListsUser"
    has_many "#{role_name}".to_sym, through: "lists_users_#{role_name}".to_sym, :class_name => "User", :source => :user
  end

  def add_user_no_sync(user)
    MailingListsService.no_sync_block do
      self.users.where(users: {id: user.id}).blank? ? self.members << user : errors.add(:user, "User already in list")
    end
  end

  def remove_user_no_sync(user)
    MailingListsService.no_sync_block do
      self.users.delete(user)
    end
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
    members_emails = self.all_members.contact_emails
    external_emails = self.ml_external_emails.where(enabled: true).pluck(:email)
    members_emails + external_emails
  end

  def members_count
    cache_name = "a#{self.email}-#{self.updated_at.to_i}-list_member_count"
    Rails.cache.fetch(cache_name, expires_in: 10.minute) do
      self.all_members.count + self.ml_external_emails.enabled.count
    end
  end

  ############# external emails #############
  def add_email(email_address,sync = true)
    era = EmailRedirectAccount.includes(:user).find_by(redirect: email_address)
    esa = EmailSourceAccount.includes(:user).find_by_full_email(email_address) if era.nil?

    if era.present?
      add_user_no_sync(era.user)
    elsif esa.present?
      add_user_no_sync(esa.user)
    else
      ExternalInvitationService.initialize_from_email(email: email_address, list: self).invite
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

  def delete_with_mailing_list_service(record)
    MailingListsService.new(record).delete
  end


  ################ members role ###############
  def set_role(user,role)
    self.lists_users.find_by(user_id: user.id)&&self.lists_users.find_by(user_id: user.id).update_attributes(role: role.to_s)
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

  ################ google link ###############

  def email_base
    email.split('@').first
  end

  def moderation_link
    "https://groups.google.com/a/gadz.org/forum/#!pendingmsg/#{email_base}"
  end

  def archive_link
    "https://groups.google.com/a/gadz.org/forum/#!forum/#{email_base}"
  end
end
