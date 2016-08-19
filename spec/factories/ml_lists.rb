FactoryGirl.define do
  factory :ml_list, class: 'Ml::List' do
    name "MyString"
    email "MyString"
    description "MyString"
    aliases "MyString"
    diffusion_policy_id "MyString"
    inscription_policy_id 1
    is_public false
    messsage_header "MyString"
    message_footer "MyString"
    is_archived false
    custom_reply_to "MyString"
    default_message_deny_notification_text "MyString"
    msg_welcome "MyString"
    msg_goodbye "MyString"
    is_archived false
    message_max_bytes_size 1
  end
end
