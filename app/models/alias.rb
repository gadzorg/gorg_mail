# == Schema Information
#
# Table name: aliases
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  redirect   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  alias_type :string(255)
#

class Alias < ActiveRecord::Base
end
