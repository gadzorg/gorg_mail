# == Schema Information
#
# Table name: email_virtual_domains
#
#  id         :integer          not null, primary key
#  name       :string
#  aliasing   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class EmailVirtualDomain < ActiveRecord::Base
	has_many :EmailSourceAccount


  def aliases
    self.class.where(aliasing: self.id)
  end
end
