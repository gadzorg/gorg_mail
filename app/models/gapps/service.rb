require 'google/apis/admin_directory_v1'
require 'googleauth'
require 'googleauth/stores/file_token_store'


module Gapps
  class Service < Google::Apis::AdminDirectoryV1::DirectoryService

    def initialize (opt={init:false})
      super()
      self.authorization=authorize!(opt)
    end

    protected

      OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'
      CLIENT_SECRETS_PATH = File.join(Rails.root,"config","gapps",Rails.env,'client_secret.json')
      CREDENTIALS_PATH = File.join(Rails.root,"config","gapps",Rails.env,"admin-directory_v1-ruby-quickstart.yml")
      SCOPE = Google::Apis::AdminDirectoryV1::AUTH_ADMIN_DIRECTORY_USER

      def authorize!(opt={init: false})
        FileUtils.mkdir_p(File.dirname(CREDENTIALS_PATH))
        client_id = Google::Auth::ClientId.from_file(CLIENT_SECRETS_PATH)
        token_store = Google::Auth::Stores::FileTokenStore.new(file: CREDENTIALS_PATH)
        authorizer = Google::Auth::UserAuthorizer.new(
          client_id, SCOPE, token_store)
        user_id = 'default'
        credentials = authorizer.get_credentials(user_id)
        if credentials.nil?
          if opt[:init]
            url = authorizer.get_authorization_url(
              base_url: OOB_URI)
            puts "Open the following URL in the browser and enter the " +
                 "resulting code after authorization"
            puts url
            code = STDIN.gets
            credentials = authorizer.get_and_store_credentials_from_code(
              user_id: user_id, code: code, base_url: OOB_URI)
          else
            raise Gapps::NoCredentialsFound
          end
        end
        credentials
      end

  end
end