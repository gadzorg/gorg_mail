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
    if message.status_code == 200
      message.validate_data_with(SCHEMA)
      Rails.logger.debug "Message data validated"
    end
  end

  def process
    if message.status_code == 200
      process_success
    else
      process_error
    end
  end

  def process_success
    #Recherche de l'utilisateur via son UUID
    user=User.find_by(uuid: message.data[:uuid])

    gapps_era=user.google_apps
    gapps_era.set_active_and_confirm

    EmailValidationMailer.notice_google_apps(user).deliver_now
  end

  def process_error
    if message.data[:error_data] && message.data[:error_data][:uuid]
      user=User.find_by(uuid: message.data[:error_data][:uuid])
      gapps_era=user.google_apps

      gapps_era.flag="broken"

      ji=Jira.new(
      user: user,
      title: "#{user.hruid}, la création de votre compte GSuite a échoué",
      labels: ["GorgMail","GoogleApps"],
      doc_ref: "https://confluence.gadz.org/pages/viewpage.action?pageId=20185205",
      dev_ref: "@ratatosk",
      message: "Bonjour #{user.firstname},

Une erreur est survenue durant la création de ton compte GSuite Gadz.org. Le problème a été transmis à l'équipe support Gadz.org pour qu'ils rêglent ça. Tu peux répondre à ce mail si tu souhaites leur founir des informations supplémentaires.

Désolé pour le retard,
Un gentil robot du support Gadz.org
",
      environment: {
      "|Erreur|"=>"| |",
      "Nom de l'erreur"=>message.error_name,
      "Message d'erreur"=>message.data[:error_message],
      "Infos de debug"=>message.data[:debug_message],
      "Infos de debug (2)"=>message.data[:error_data],
      }
      ).send

      gapps_era.broken_info="Voir #{ji.key}"
      gapps_era.save

    end
  end
end
