# == Schema Information
#
# Table name: ml_external_emails
#
#  id              :integer          not null, primary key
#  list_id         :integer
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  enabled         :boolean
#  accepted_cgu_at :datetime
#
# Indexes
#
#  index_ml_external_emails_on_email    (email)
#  index_ml_external_emails_on_list_id  (list_id)
#

class Ml::ExternalEmail < ApplicationRecord
  belongs_to :ml_list, :class_name => 'Ml::List', :foreign_key => "list_id"

  validates :email, uniqueness: { scope: :list_id} , presence: true, format: { with: /\A([^@+\s\'\`]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}

  before_create :set_default

  scope :enabled , (->{where(enabled:true)})

  include TokenableConcern

  def self.find_email(email)
    self.find_by(email: email)
  end

  def self.find_all_email(email)
    self.where(email: email)
  end

  def set_default
    self.tap do |ee|
      ee.enabled||= false
      ee.accepted_cgu_at||= nil
    end
  end


end
