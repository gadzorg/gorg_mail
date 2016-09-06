# == Schema Information
#
# Table name: ml_external_emails
#
#  id         :integer          not null, primary key
#  list_id    :integer
#  email      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Ml::ExternalEmail < ActiveRecord::Base
  belongs_to :ml_list, :class_name => 'Ml::List'
end
