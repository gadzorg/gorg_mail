namespace :gorg_service do
  desc 'Run gorgservice daemon'
  task :run => :environment do

    service=GorgService.new

    service.run
    
  end
end