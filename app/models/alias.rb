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
#  list_id                 :integer
#
# Indexes
#
#  index_aliases_on_email                    (email)
#  index_aliases_on_email_virtual_domain_id  (email_virtual_domain_id)
#  index_aliases_on_list_id                  (list_id)
#  index_aliases_on_redirect                 (redirect)
#

class Alias < ActiveRecord::Base
  belongs_to :email_virtual_domain,  class_name: "EmailVirtualDomain"
  belongs_to :ml_list, :class_name => 'Ml::List', :foreign_key => "list_id"

  validates_presence_of :email_virtual_domain


  def to_s
    "#{self.email}@#{self.email_virtual_domain.name}"
  end

  def self.new_for_mailinglist(mailinglist)
    ml_email_base, ml_domain = mailinglist.email.split('@')

    if ml_domain == Configurable[:main_mail_domain]
      ml_virtual_domain = EmailVirtualDomain.find_by(name: ml_domain)
      ml_redirect_domain = Configurable[:default_google_apps_domain_alias]
      ml_redirect_email = "#{ml_email_base}@#{ml_redirect_domain}"
      Alias.create(email: ml_email_base, email_virtual_domain: ml_virtual_domain, redirect: ml_redirect_email, list_id: mailinglist.id)


      # If mailinglist email is not the main google apps domain (i.e subdomain)
      # - update the ML domain for a the main mail domain
      # - create alias with the old domain to the google apps domain
    elsif ml_domain.split(".").last(2).join(".") == Configurable[:main_mail_domain]
      #ml_email_base = burs
      #ml_domain = jp.gadz.org

      sub_domain = ml_domain.gsub("."+ Configurable[:main_mail_domain], "")
      #sub_domain = jp

      ml_email_base_new = ml_email_base + "." + sub_domain
      #ml_email_base_new = burs.jp

      ml_domain_new = Configurable[:main_mail_domain]
      #ml_domain_new = gadz.org

      mailinglist.email = ml_email_base_new + "@" + ml_domain_new
      mailinglist.save

      ml_virtual_domain = EmailVirtualDomain.find_by(name: ml_domain)
      ml_redirect_domain = Configurable[:default_google_apps_domain_alias]
      ml_redirect_email = "#{ml_email_base_new}@#{ml_redirect_domain}"
      #ml_redirect_email = burs.jp@gadz.fr
      Alias.create(email: ml_email_base, email_virtual_domain: ml_virtual_domain, redirect: ml_redirect_email, list_id: mailinglist.id)
    end

  end

  def self.find_by_email(email)
    email_base, email_domain = email.split('@')
    evd = EmailVirtualDomain.find_by(name: email_domain)
    Alias.where(email: email_base, email_virtual_domain: evd).take
  end

  def self.search(query)
    self.includes(:email_virtual_domain).where("CONCAT(email,'@',email_virtual_domains.name) LIKE :query OR redirect LIKE :query",query: "%#{query}%").references(:email_virtual_domain)
  end
end
