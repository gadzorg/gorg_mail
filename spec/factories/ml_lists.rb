FactoryGirl.define do
  factory :ml_list, class: 'Ml::List' do
    name "MyString"
    email "MyString"
    description "MyString"
    aliases "MyString"
    diffusion_policy %w(open closed moderated).sample
    inscription_policy %w(open closed in_group).sample
    is_public false
    messsage_header "MyString"
    message_footer "MyString"
    is_archived false
    custom_reply_to "MyString"
    default_message_deny_notification_text "MyString"
    msg_welcome "MyString"
    msg_goodbye "MyString"
    message_max_bytes_size 1
    group_uuid nil
  end
end
