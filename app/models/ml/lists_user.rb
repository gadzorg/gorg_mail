# == Schema Information
#
# Table name: ml_list_users
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  ml_list_id       :integer
#  is_ban           :boolean
#  pending          :boolean
#  is_on_white_list :boolean
#  is_moderator     :boolean
#  is_admin         :boolean
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Ml::ListsUser < ActiveRecord::Base
  validates :user_id, presence: true
  validates :list_id, presence: true

  before_save :initialize

  def initialize
    self.is_ban ||= false
    self.is_admin ||= false
    self.is_moderator ||= false
    self.is_on_white_list ||= false
  end
end
