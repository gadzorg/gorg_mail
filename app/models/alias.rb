# == Schema Information
#
# Table name: aliases
#
#  id         :integer          not null, primary key
#  email      :string
#  redirect   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Alias < ActiveRecord::Base
end
