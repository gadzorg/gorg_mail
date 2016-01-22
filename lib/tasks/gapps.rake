namespace :gapps do
  desc "TODO"
  task authorize_oauth: :environment do

    key=nil
    while(%w(y n).exclude? key)
      puts "Before continuing this task, ensure you put necessary client_secret.json in config/gapps/#{Rails.env} (y/n)"
      key= STDIN.gets.chomp
    end

    Gapps::Service.new(init:true) if key == "y"
  end

end
