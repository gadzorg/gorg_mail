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


  def aliases
    self.class.where(aliasing: self.id)
  end

  def aliasing_name
    al = EmailVirtualDomain.where(id: self.aliasing).first
    al.name if al.present?
  end

  def aliasing_name_if_not_self
    aln = self.aliasing_name
    aln.nil? || aln == self.name ? "" : aln
  end
end
