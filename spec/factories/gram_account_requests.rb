# class GramAccountMocker
#
#   DEFAULT_GRAM_ACCOUNT={
#       "uuid"=>"559bb0aa-ddac-4607-ad41-7e520ee40819",
#       "hruid"=>"alexandre.narbonne.2011",
#       "firstname"=>"Alexandre",
#       "lastname"=>"NARBONNE",
#       "id_soce"=>"84189",
#       "enable"=>"TRUE",
#       "id"=>85189,
#       "uid_number"=>85189,
#       "gid_number"=>85189,
#       "home_directory"=>"/nonexistant",
#       "alias"=>["alexandre.narbonne.2011", "84189", "84189J"],
#       "password"=>"Not Display",
#       "email"=>"alexandre.narbonne",
#       "email_forge"=>"alexandre.narbonne@gadz.org",
#       "birthdate"=>"1987-09-17 00:00:00",
#       "login_validation_check"=>"CGU=2015-06-04;",
#       "description"=>"Agoram inscription - via module register - creation 2015-06-04 11:32:48",
#       "entities"=>["comptes", "gram"],
#       "is_gadz"=>"true",
#   }
#
#   attr_reader :attributes
#
#   def initialize(attr={})
#     @attributes=attr
#   end
#
#   def uuid
#     attributes["uuid"]
#   end
#
#   def self.for(hash={})
#     self.new(DEFAULT_GRAM_ACCOUNT.merge(hash))
#   end
#
#   def mock_get_request
#     ActiveResource::HttpMock.respond_to({},false) do |mock|
#       mock.get "/api/v2/accounts/#{uuid}.json", {"Authorization"=>authorization_header,'Accept' => 'application/json'}, attributes.to_json, 200
#     end
#   end
#
#   def mock_search_request_for(param,value=nil,response=[attributes])
#     value||=attributes[param.to_s]
#     value=URI.escape(URI.escape(value.to_s),"@")
#     response=response.to_json unless response.is_a? String
#     ActiveResource::HttpMock.respond_to({},false) do |mock|
#       mock.get "/api/v2/accounts.json?#{param.to_s}=#{value}", {"Authorization"=>authorization_header,'Accept' => 'application/json'}, response, 200
#     end
#   end
#
#   private
#
#   def authorization_header
#     ActionController::HttpAuthentication::Basic.encode_credentials(
#         Rails.application.secrets.gram_api_user,
#         Rails.application.secrets.gram_api_password
#     )
#   end
#
# end