# == Schema Information
#
# Table name: ml_lists_users
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  list_id          :integer
#  is_on_white_list :boolean
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  role             :integer          default(3)
#
# Indexes
#
#  index_ml_lists_users_on_user_id_and_list_id  (user_id,list_id)
#

class Ml::ListsUser < ActiveRecord::Base

  belongs_to :user
  belongs_to :list, class_name: 'Ml::List'

  validates :user_id, presence: true
  validates :list_id, presence: true


  enum role: [:banned, :pending, :member, :moderator, :admin ]
  #Crée le scope plurielalisé de chaque role
  roles.keys.each do |role|
    scope role.pluralize.to_sym, -> { send(role) }
  end
  scope :all_members, -> { where("role > ?",self.roles['member']) } 


  def initialize(args={})
    super(args)
    self.role ||= "member"
    self.is_on_white_list ||= false
  end

  def role_id
    self.class.roles[self.role]
  end

  def in_all_members?
    role_id > self.class.roles['member']
  end

end
