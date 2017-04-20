class Jira

  MRM_PROJECT_ID="10001"
  #MRM_PROJECT_ID="11000"

  attr_accessor :user
  attr_accessor :message
  attr_accessor :environment
  attr_accessor :title
  attr_accessor :labels

  def initialize(user: nil, message: nil, environment: {}, title: "Une erreur est survenue", labels: [])
    self.user=user
    self.message=message
    self.environment = environment
    self.title = title
    self.labels = labels
  end

  def default_environment
    h={"|Application|"=>Rails.application.secrets.app_name}
    h.merge!(user_environment) if user
  end

  def default_labels
    ["TicketAutomatique"]
  end

  def user_environment
    {
        "|Infos User|"=>"| |",
        "UUID" => "[#{@user.uuid}|#{link_for_uuid(@user.uuid)}]",
        "HRUID" => @user.hruid,
        "Prénom" => @user.firstname,
        "Nom" => @user.lastname,
    }
  end

  def environment
    default_environment.merge(@environment.to_h)
  end

  def labels
    (@labels+default_labels).uniq
  end

  def send
    JiraIssue.create(
        fields: {
            project: { id: MRM_PROJECT_ID },
            summary: title,
            description: message,
            environment: format_hash_to_table(environment),
            customfield_10000: @user.try(:email) ,
            issuetype: { id: "1" },
            labels: labels
        })
  end

  private

    def link_for_uuid(uuid)
      "https://moncompte.gadz.org/admin/info_user?uuid=#{user.uuid}"
    end

    def format_hash_to_table(hash)
      hash.map{|k,v| "|#{k}|#{v}|"}.join("\n")
    end

end