#Alow usage of other YAML config files.
#Each keys can be overwrited with an ENV variable prefixed by @env_prefix

#Example
#
### YAML FILE
# default: &default
#   some_key: "somedata"
# development:
#   <<: *default
# test:
#   <<: *default
# production:
#   <<: *default
#
### Application.rb
#
# CUSTOM_CONFIG=ExtraConfig.new(File.expand_path("config/my_file.yml",Rails.root),"SOMEPREFIX")
#
### Usage
#
# CUSTOM_CONFIG[:some_key]
# =>  "somedata"
#
# If ENV["SOMEPREFIX_SOME_KEY"]="other data"
#
# CUSTOM_CONFIG[:some_key]
# =>  "other data"

class ExtraConfig
  def initialize(file_path=nil, env_prefix="" , env=Rails.env)
    @env_prefix=env_prefix
    @yaml_config = (file_path && File.exist?(file_path)) ? YAML::load(File.open(file_path))[env] : {}
  end

  def [](k)
    key=k.to_s
    env_value(key)|| @yaml_config[key]
  end

  def env_value(key)
    env_var_name="#{@env_prefix}_#{key.to_s.upcase}"
    ENV[env_var_name]
  end
end
