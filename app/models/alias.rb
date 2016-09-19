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
# Indexes
#
#  index_aliases_on_email                    (email)
#  index_aliases_on_email_virtual_domain_id  (email_virtual_domain_id)
#  index_aliases_on_redirect                 (redirect)
#

class Alias < ActiveRecord::Base
  belongs_to :email_virtual_domain,  class_name: "EmailVirtualDomain"

  def to_s
    "#{self.email}@#{self.email_virtual_domain.name}"
  end

  def self.new_for_mailinglist(mailinglist)
    ml_email_baee, ml_domain = mailinglist.email.split('@')
    if ml_domain == Configurable[:main_mail_domain]
      ml_virtual_domain = EmailVirtualDomain.find_by(name: ml_domain)
      ml_redirect_domain = Configurable[:default_google_apps_domain_alias]
      ml_redirect_email = "#{ml_email_baee}@#{ml_redirect_domain}"
      Alias.create(email: ml_email_baee, email_virtual_domain: ml_virtual_domain, redirect: ml_redirect_email)
    end
  end

  def self.find_by_email(email)
    email_base, email_domain = email.split('@')
    evd = EmailVirtualDomain.find_by(name: email_domain)
    Alias.where(email: email_base, email_virtual_domain: evd).take
  end
end
