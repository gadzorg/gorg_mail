require "json-schema"

class GramAccountUpdatedMessageHandler < GorgService::Consumer::MessageHandler::EventHandler

  listen_to "notify.account.updated"
  listen_to "notify.account.created"

  def validate
    Rails.logger.debug "No message validation"
  end

  def process
    #Recherche de l'utilisateur via son UUID
    user=User.find_or_initialize_by(uuid: message.data[:key]) do |u|
      # Default values in case of new user
      u.password=Devise.friendly_token[0,20]
    end

    user.hruid=message.data[:changes][:hruid][1] if message.data[:changes][:hruid]
    user.lastname=message.data[:changes][:lastname][1] if message.data[:changes][:lastname]
    user.firstname=message.data[:changes][:firstname][1] if message.data[:changes][:firstname]
    user.email=message.data[:changes][:email][1] if message.data[:changes][:email]
    user.is_gadz=message.data[:changes][:is_gadz][1] if message.data[:changes][:is_gadz]

    user.last_gram_sync_at = Time.now

    unless user.save
      # Data from message are not enougth to create a user, we need to ask GrAM
      user.update_from_gram
    end
  end
end
