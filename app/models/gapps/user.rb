require 'google/apis/admin_directory_v1'
require 'googleauth'
require 'googleauth/stores/file_token_store'

module Gapps
  class User < Google::Apis::AdminDirectoryV1::User


    def self.find user_key
      new(gapps.get_user(user_key).to_h)
    end

    def reload
      self.update!(self.class.gapps.get_user(self.primary_email).to_h)
    end

    def save
      self.update!(self.class.gapps.update_user(self.primary_email, self).to_h)
      self.reload
    end

    protected
      def self.gapps
        @@service ||= Gapps::Service.new
      end
  end
end