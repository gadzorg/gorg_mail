# == Schema Information
#
# Table name: ml_external_emails
#
#  id         :integer          not null, primary key
#  list_id    :integer
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Ml::ExternalEmail < ActiveRecord::Base
  belongs_to :ml_list, :class_name => 'Ml::List'

  validates :email, uniqueness: { scope: :list_id} , presence: true
end
