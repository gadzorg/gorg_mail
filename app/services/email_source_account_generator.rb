require "i18n"
class EmailSourceAccountGenerator

  DEFAULT_DOMAIN='gadz.org'

  def initialize(user)
    @user=user
  end


  def generate
    return false if @user.email_source_accounts.any?
    clean_firstname=clean(@user.firstname)
    clean_lastname=clean(@user.lastname)

    base="#{clean_firstname}.#{clean_lastname}"
    if EmailSourceAccount.find_by(email: base, email_virtual_domain_id: default_domain.id)
      raise 'No HRUID' unless @user.hruid
      create_with_base(@user.hruid)
    else
      create_with_base(base)
    end
    @user.email_source_accounts
  end

  private

    def clean(name)
      #remplacement des espaces et apostrophes par des "-"
      name = name.downcase
      name = name.gsub(" ", "-")
      name = name.gsub("'", "-")
      name = name.gsub("’", "-")
      name = name.gsub("`", "-")

      # suppression des accents
      name = I18n.transliterate(name)
      name = name.gsub(/[^a-z\-]/, "")
      return name
    end

    def default_domain
      EmailVirtualDomain.find_by(name: DEFAULT_DOMAIN)
    end

    def aliases_domains
      default_domain.aliases
    end

    def create_with_base(base)
      aliases_domains.each do |d|
        @user.email_source_accounts.create(
          email: base,
          email_virtual_domain: d
          )
      end
    end
end