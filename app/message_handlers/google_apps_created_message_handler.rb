require "json-schema"

class GoogleAppsCreatedMessageHandler < GorgService::Consumer::MessageHandler::ReplyHandler

  listen_to "reply.googleapps.user.create"

  SCHEMA={"$schema"=>"http://json-schema.org/draft-04/schema#",
          "title"=>"Google Apps Created message schema",
          "type"=>"object",
          "properties"=> {
              "uuid"=>{"type"=>"string",
                       "description"=>"The unique identifier of linked GrAM Account",
                       "pattern"=>"[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}"
              },
              "google_id"=> {
                  "type"=>"string",
                  "description"=>"Long name of the group"
              }
          },
          "additionalProperties"=>true,
          "required"=>[
              "uuid",
              "google_id"
          ]
  }

  def validate
    message.validate_data_with(SCHEMA)
    Application.logger.debug "Message data validated"
  end

  def process
    #Recherche de l'utilisateur via son UUID
    user=User.find_by(uuid: message.data[:uuid])

    gapps_era=user.google_apps
    gapps_era.set_active_and_confirm

    EmailValidationMailer.notice_google_apps(user).deliver_now
  end
end
