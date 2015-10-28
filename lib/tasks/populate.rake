# lib/tasks/populate.rake
#
# Rake task to populate development database with test data
# Run it with "rake db:populate"
# See Railscast 126 and the faker website for more information

namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do

    require 'faker'

    Rake::Task['db:reset'].invoke

    # Create admin_user account
    admin_user = User.create!(:email => "admin@poubs.org",
                              :firstname => Faker::Name.first_name,
                              :lastname => Faker::Name.last_name,
                              :password => "password",
                              :password_confirmation => "password",
                              :role => Role.find_by_name(:admin)
                              )


    puts "Admin mail = #{admin_user.email}"
    puts "Admin name = #{admin_user.fullname}"


  end
end