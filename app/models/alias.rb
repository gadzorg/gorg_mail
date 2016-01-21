# == Schema Information
#
# Table name: aliases
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  email      :string
#  redirect   :string
#

class Alias < ActiveRecord::Base
end
