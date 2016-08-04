# == Schema Information
#
# Table name: aliases
#
#  id                      :integer          not null, primary key
#  email                   :string(255)
#  redirect                :string(255)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  alias_type              :string(255)
#  email_virtual_domain_id :string(255)
#  expire                  :date
#  srs_rewrite             :integer
#

class Alias < ActiveRecord::Base
  belongs_to :email_virtual_domain,  class_name: "EmailVirtualDomain"

  def to_s
    "#{self.email}@#{self.email_virtual_domain.name}"
  end
end
