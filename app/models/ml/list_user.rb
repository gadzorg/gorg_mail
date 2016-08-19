# == Schema Information
#
# Table name: ml_list_users
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  list_id          :integer
#  is_ban           :boolean
#  pending          :boolean
#  is_on_white_list :boolean
#  is_moderator     :boolean
#  is_admin         :boolean
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Ml::ListUser < ActiveRecord::Base
end
