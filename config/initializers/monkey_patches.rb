# config/initializers/monkey_patches.rb
require 'active_resource/formats'

# module ActiveResource
#   module Formats
#     def self.remove_root(data)
#       if data.is_a?(Hash) && data.keys.size == 1 && data.values.first.is_a?(Enumerable)
#         data.values.first
#       else
#         data.first
#       end
#     end
#   end
# end