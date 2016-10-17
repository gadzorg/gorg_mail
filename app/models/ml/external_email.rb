# == Schema Information
#
# Table name: ml_external_emails
#
#  id         :integer          not null, primary key
#  list_id    :integer
#  email      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_ml_external_emails_on_email    (email)
#  index_ml_external_emails_on_list_id  (list_id)
#

class Ml::ExternalEmail < ActiveRecord::Base
  belongs_to :ml_list, :class_name => 'Ml::List', :foreign_key => "list_id"

  validates :email, uniqueness: { scope: :list_id} , presence: true, format: { with: /\A([^@+\s\'\`]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}


end
