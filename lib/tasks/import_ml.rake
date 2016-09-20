namespace :import_ml do
  require 'csv'
  require 'benchmark'
  desc "TODO"
  task import_ml: :environment do


    CSV_ML_LIST_PATH=File.join(Rails.root,'lib/assets/ml_list.csv')

    puts "Load CSV..."
    ml_list=CSV.parse(File.read(CSV_ML_LIST_PATH),headers: true)
    puts "Done!"
    puts "Load ML..."

    ml_list.each do |ml_row|
      if ml_row["email"]
        puts ml_row["name"] + "  " + ml_row["email"] + "  " + ml_row["max_message_size"]
        a = Ml::List.new(
            name:ml_row["name"],
            email:ml_row["email"],
            description:ml_row["description"],
            aliases: (ml_row["aliases"].nil? ? "" : ml_row["aliases"]), # alias séparés par des virgules
            diffusion_policy:ml_row["diffusion_policy"], # open closed moderated
            messsage_header:ml_row["messsage_header"],
            message_footer:ml_row["message_footer"],
            is_archived: true,
            custom_reply_to: ml_row["custom_reply_to"],
            default_message_deny_notification_text: nil,
            msg_welcome:ml_row["msg_welcome"],
            msg_goodbye:ml_row["msg_goodbye"],
            message_max_bytes_size:ml_row["max_message_size"].to_i,
            inscription_policy:ml_row["inscription_policy"], #open conditional_gadz closed in_group
        )
        puts a.inspect
        a.save
        end
    end
    puts "Done!"
  end
  desc "Import ML members"
  task import_members: :environment do

    puts "Load CSV..."

    CSV_ML_MEMBERS_PATH=File.join(Rails.root,'lib/assets/ml_members.csv')
    ml_members=CSV.parse(File.read(CSV_ML_MEMBERS_PATH),headers: true)
    puts "Done!"


    puts "Load ML members..."

    members_count = ml_members.count.to_f
    members_imported = 0.to_f
    start_date = DateTime.now

    CSV.foreach(CSV_ML_MEMBERS_PATH,{:headers => :first_row}) do |ml_member_row|

      elapsed_time =(DateTime.now - start_date)*1.days
      remaining_time = elapsed_time/members_imported * (members_count-members_imported)
      percentage = (members_imported/(members_count+1)*100)

      puts members_imported.to_s + " / " + members_count.to_s + " | "+ percentage.round(2).to_s + "% | Temps écoulé : " +elapsed_time.round(2).to_s + "s | Temps restant : " + remaining_time.round(2).to_s + "s | "+ ml_member_row["list_email"] + " " + ml_member_row["member_email"]

      puts Benchmark.measure {
        ml=Ml::List.find_by(email: ml_member_row["list_email"])

        #search in renamed ML
        if ml.nil?
          e= ml_member_row["list_email"]
          ml_email_base, ml_domain = e.split('@')
          new_email = ml_email_base + "." +ml_domain.gsub(".gadz.org", "") + "@gadz.org"
          puts new_email
          ml=Ml::List.find_by(email: new_email)

        end

        ml.add_email(ml_member_row["member_email"],false) #add email w/o sync
      }
      members_imported +=1

    end

    puts "Done!"
    puts "Resync all ML..."
    puts Benchmark.measure {
      Ml::List.all.each{|ml| ml.sync_with_mailing_list_service}
    }
    puts "Done! YOU ROCK!"

  end
end
