# == Schema Information
#
# Table name: email_source_accounts
#
#  id                      :integer          not null, primary key
#  email                   :string
#  uid                     :integer
#  type_source             :integer
#  flag                    :string
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

	def self.create_standard_aliases_for(user)
		canonical_name = user.canonical_name
		return false if canonical_name.nil?

		%w[gadz.org gadzarts.org m4am.net].each do |domain|
			esa = EmailSourceAccount.new(
			email: canonical_name,
			email_virtual_domain_id: EmailVirtualDomain.find_by(name: domain).id
			)
			esa.email = user.hruid unless  esa.valid_attribute?(:email)
			user.email_source_accounts << esa
		end

	end

	def valid_attribute?(attribute_name)
		self.valid?
		self.errors[attribute_name].blank?
	end

end
