# == Schema Information
#
# Table name: email_redirect_accounts
#
#  id                 :integer          not null, primary key
#  uid                :integer
#  redirect           :string(255)
#  rewrite            :string(255)
#  type_redir         :string(255)
#  action             :string(255)
#  broken_date        :date
#  broken_level       :integer
#  last               :date
#  flag               :string(255)
#  allow_rewrite      :integer
#  srs_rewrite        :string(255)
#  confirmation_token :string(255)
#  confirmed          :boolean          default(TRUE)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  user_id            :integer
#
# Indexes
#
#  index_email_redirect_accounts_on_confirmation_token  (confirmation_token) UNIQUE
#  index_email_redirect_accounts_on_flag                (flag)
#  index_email_redirect_accounts_on_redirect            (redirect)
#  index_email_redirect_accounts_on_type_redir          (type_redir)
#  index_email_redirect_accounts_on_user_id             (user_id)
#

class EmailRedirectAccount < ActiveRecord::Base
	belongs_to :user

  validates :redirect, :uniqueness => {:scope => :user_id}
  validates :redirect, :email => true, format: { with: /\A([^@+\s\'\`]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}
  after_create :email_redirect_account_completer

  def generate_new_token()
    self.confirmation_token = loop do
      token = SecureRandom.urlsafe_base64
      break token unless EmailRedirectAccount.exists?(confirmation_token: token)
    end
    self.confirmed = false
  end
  
  def set_active
    # chek if not broken? TODO
    # check number of activated emails
    # activate if less than 2 ( ce serait bien d'utiliser le gem configurable)
    if self.user.email_redirect_accounts.where(:flag => "active").where(:type_redir => "smtp").count < Configurable.max_actives_era
      self.flag = "active"
      self.save 
    else
      return false
    end
  end

  def set_inactive
    self.flag = "inactive"
    self.save
  end

  def set_broken
    self.flag = "broken" 
    self.save
  end

  def active?
    if self.flag == "active"
      return true
    else
      return false
    end
  end

  def inactive?
    if self.flag == "inactive"
      return true
    else
      return false
    end
  end

  def broken?
    if self.flag == "broken"
      return true
    else
      return false
    end
  end

  def set_confirmed
    self.confirmed = true
    self.save
  end

  def set_unconfirmed
    self.confirmed = false
    self.save
  end

  def set_active_and_confirm
    set_active && set_confirmed
  end

  def set_inactive_and_unconfirmed
    set_inactive && set_unconfirmed
  end

  def is_internal_domains_address?
    domains = (Configurable[:default_mail_domains] + " " + Configurable[:default_google_apps_domain_alias]).split.uniq
    era_domain = self.redirect.split("@").last
    domains.include?(era_domain)
  end


  def email_redirect_account_completer
    self.set_rewrite
  end

  def set_rewrite
    self.rewrite = self.user.primary_email
    self.allow_rewrite = 1
    self.save
  end
end
