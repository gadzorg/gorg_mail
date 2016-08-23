require "i18n"
class EmailSourceAccountGenerator

  DEFAULT_DOMAIN='gadz.org'

  def initialize(user, options = {})
    @user=user
    @domain=options[:domain] || DEFAULT_DOMAIN
  end

  def generate
    #return false if @user.email_source_accounts.any?
    clean_firstname=clean(@user.firstname)
    clean_lastname=clean(@user.lastname)
    base="#{clean_firstname}.#{clean_lastname}"
    if @user.canonical_name
      base="#{clean(@user.canonical_name)}"
    else
      raise "No canonical name"
    end
    # if @user.hruid ? base="#{clean(@user.canonical_name)}" : raise "No canonical name"
    if EmailSourceAccount.find_by(email: base, email_virtual_domain_id: domain.id)
      raise 'No HRUID' unless @user.hruid
      create_with_base(@user.hruid)
    else
      create_with_base(base)
    end
    return @user.email_source_accounts
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
      name = name.gsub(/[^a-z\.\-0-9]/, "")
      return name
    end

    def domain
      @evd ||= EmailVirtualDomain.find_by(name: @domain)
    end

    def aliases_domains
      if @domain
          domain.aliases
        else
          default_domain.aliases
      end
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