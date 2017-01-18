module ApplicationHelper


  def slack_chat?
    Configurable[:use_helpdesk_chat] and (current_user or Configurable[:anonymous_helpdesk_chat])
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
