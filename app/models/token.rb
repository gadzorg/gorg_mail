# == Schema Information
#
# Table name: tokens
#
#  id             :integer          not null, primary key
#  token          :string(255)
#  tokenable_id   :integer
#  tokenable_type :string(255)
#  scope          :string(255)
#  expires_at     :datetime
#  used_at        :datetime
#  data           :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_tokens_on_token  (token) UNIQUE
#

class Token < ActiveRecord::Base

  belongs_to :tokenable, polymorphic: true
  serialize :data, Hash

  before_create :set_default

  scope :usable, -> { unused.unexpired }

  scope :unused, -> { where(used_at: nil)}
  scope :unexpired, -> { where('expires_at > NOW()')}


  DEFAULT_TOKEN_LIFETIME=3.days

  def generate_token
    self.token=loop do
      random_token=SecureRandom.urlsafe_base64(nil,false)
      break random_token unless self.class.exists?(token: random_token)
    end
  end

  def used?
    !!self.used_at
  end

  def set_used
    self.update_attributes(used_at: DateTime.now)
  end

  def set_default
    self.tap do |mt|
      mt.expires_at||=DateTime.now+DEFAULT_TOKEN_LIFETIME
      mt.token||=generate_token
    end
  end

  def self.find_by_token_and_set_used(token)
    self.find_by(token: token).tap do |mt|
      mt.used_at=DateTime.now
      mt.save
    end
  end

end
