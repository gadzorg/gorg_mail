# == Schema Information
#
# Table name: email_virtuals
#
#  id          :integer          not null, primary key
#  email       :string(255)
#  domain      :integer
#  redirect    :string(255)
#  type_alias  :integer
#  expire      :date
#  srs_rewrite :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class EmailVirtual < ActiveRecord::Base
		belongs_to :email_virtual_domain,  class_name: "EmailVirtualDomain", foreign_key: "domain"
end
