# == Schema Information
#
# Table name: postfix_blacklists
#
#  id          :integer          not null, primary key
#  email       :string
#  reject_text :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class PostfixBlacklist < ActiveRecord::Base
end
