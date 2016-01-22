# == Schema Information
#
# Table name: email_virtual_domains
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  aliasing   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class EmailVirtualDomain < ActiveRecord::Base
	has_many :EmailSourceAccount
end
