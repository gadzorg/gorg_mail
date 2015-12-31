module UserHelper
  def display_attribute(attribute)
    render partial:'users/attribute_value', :locals => { 
      attribute: attribute 
		}
  end
end