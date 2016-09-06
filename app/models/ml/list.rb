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

class Ml::List < ActiveRecord::Base
  # keep this function before validation
  def self.inscription_policy_list
    %w(open conditional_gadz closed in_group)
  end

  validates :name, uniqueness: true, presence: true
  validates :email, uniqueness: true, presence: true
  # validates :diffusion_policy, presence: true, acceptance: { accept: %w(open closed moderated) }
  validates_inclusion_of :diffusion_policy, :in => %w(open closed moderated)
  validates_inclusion_of :inscription_policy, :in => Ml::List.inscription_policy_list
  validates_inclusion_of :is_archived, :in => [true, false]
  validates :message_max_bytes_size, presence: true

  has_and_belongs_to_many :users
  has_many :ml_external_emails, :class_name => 'Ml::ExternalEmail'

  def add_user(user)
    self.users << user unless self.users.include?(user) or user.lists_allowed.exclude?(self)
  end

  def remove_user(user)
    self.users.delete(user)
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
    Ml::List.where(inscription_policy: "open").includes(:users)
  end

  ############# external emails #############
  def add_email(email_address)
    era = EmailRedirectAccount.find_by(redirect: email_address)
    if era.nil?
      email_external = Ml::ExternalEmail.new(email: email_address)

      self.ml_external_emails << email_external
      email_external.save
    else
      add_user(era.user)
    end
  end

  def remove_email(email_external)
    self.delete(email_external)
  end



end
