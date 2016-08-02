# == Schema Information
#
# Table name: email_source_accounts
#
#  id                      :integer          not null, primary key
#  email                   :string(255)
#  uid                     :integer
#  type_source             :integer
#  flag                    :string(255)
#  expire                  :date
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  user_id                 :integer
#  email_virtual_domain_id :integer
#
# Indexes
#
#  index_email_source_accounts_on_email_virtual_domain_id  (email_virtual_domain_id)
#  index_email_source_accounts_on_user_id                  (user_id)
#

class EmailSourceAccount < ActiveRecord::Base
	belongs_to :email_virtual_domain
	belongs_to :user

  validates :email, :uniqueness => {:scope => :email_virtual_domain_id}, presence: true
	validates :email_virtual_domain, presence: true
	validates :user, presence: true


	def to_s
		"#{self.email}@#{self.email_virtual_domain.name}"
	end
	alias_method :full_email_address, :to_s

# TODO: move this function in email_source_account_generator service
	def self.create_standard_aliases_for(user)
		Configurable[:default_mail_domains].split.each do |domain|
			EmailSourceAccountGenerator.new(user, domain: domain).generate
		end
	end

end
