# == Schema Information
#
# Table name: postfix_blacklists
#
#  id          :integer          not null, primary key
#  email       :string(255)
#  reject_text :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class PostfixBlacklist < ActiveRecord::Base
end
