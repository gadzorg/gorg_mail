module ApplicationHelper


  def slack_chat?
    Configurable[:use_helpdesk_chat] and (current_user or Configurable[:anonymous_helpdesk_chat])
  end

  def slack_chat_box

    user_name = current_user ? current_user.fullname : "Utilisateur Anonyme - " + session.id[0..4].upcase
    user_id = current_user ? current_user.hruid.to_s : ""
    user_link = current_user ? "https://agoram.gadz.org/admin/a/edit/"+user_id : "moncompte.gadz.org"

    render partial:'shared/slack_chat', :locals => { 
      :user_name => user_name,
      :user_id => user_id,
      :user_link => user_link
      }
  end

  def display_attribute(item, attribute)
    render partial:'shared/attribute_value', :locals => { 
      attribute: attribute,
      item: item  
    }
  end

  def google_analytics_id
    Rails.application.secrets.google_analytics_id
  end

end
