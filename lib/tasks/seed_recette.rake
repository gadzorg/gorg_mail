# lib/tasks/populate.rake
#
# Rake task to populate development database with test data
# Run it with "rake db:populate"
# See Railscast 126 and the faker website for more information

namespace :db do
  desc "Seed recette data"
  task :seed_recette => :environment do
    puts "Environement = #{Rails.env}"
    require 'faker'

    Role.create [{name: :admin},{name: :support}]

    puts "Create Virtual Domains"

    list_domain=[['poubs.org', '1'],
                 ['m4am.net', '2'],
                 ['gadzarts.org', '1']]

    list_domain.each do |d|
      a=EmailVirtualDomain.create(
          :name => d[0],
          :aliasing => d[1]
      )
      a.save

      puts "Reconfig default domains"
      Configurable[:default_mail_domains] = "poubs.org m4am.net"

    end
  end
end