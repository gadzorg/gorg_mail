namespace :gorg_service do
  desc 'Run gorgservice daemon'
  task :run => :environment do

    service=GorgService::Consumer.new
    puts " [*] Running with pid #{Process.pid}"
    puts " [*] Running in #{Rails.env} environment"
    puts " [*] To exit press CTRL+C or send a SIGINT"
    service.run
    
  end
end