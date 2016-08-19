# == Schema Information
#
# Table name: ml_lists
#
#  id                                     :integer          not null, primary key
#  name                                   :string(255)
#  email                                  :string(255)
#  description                            :string(255)
#  aliases                                :string(255)
#  diffusion_policy_id                    :string(255)
#  inscription_policy_id                  :integer
#  is_public                              :boolean
#  messsage_header                        :string(255)
#  message_footer                         :string(255)
#  is_archived                            :boolean
#  custom_reply_to                        :string(255)
#  default_message_deny_notification_text :string(255)
#  msg_welcome                            :string(255)
#  msg_goodbye                            :string(255)
#  message_max_bytes_size                 :integer
#  created_at                             :datetime         not null
#  updated_at                             :datetime         not null
#

class Ml::List < ActiveRecord::Base

end
