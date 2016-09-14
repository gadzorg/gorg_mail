require "json-schema"

class GoogleAppsCreatedMessageHandler < ApplicationMessageHandler
  
  def validate_payload
    schema={"$schema"=>"http://json-schema.org/draft-04/schema#",
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

    errors=JSON::Validator.fully_validate(schema, msg.data)
    if errors.any?
      Rails.logger.error "Data validation error : #{errors.inspect}"
      raise_hardfail("Data validation error", error: errors.inspect)
    end

    Rails.logger.debug "Message data validated"
  end

  def process
    #Recherche de l'utilisateur via son UUID
    user=User.find_by(uuid: msg[:uuid])

    gapps_era=user.google_apps
    gapps_era.set_active_and_confirm

    #Todo : mailler
    
    
  end
end
