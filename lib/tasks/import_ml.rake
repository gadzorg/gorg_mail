namespace :import_ml do
  desc "TODO"
  task import_csv: :environment do
    require 'csv'

    CSV_ML_LIST_PATH=File.join(Rails.root,'lib/assets/ml_list.csv')
    CSV_ML_MEMBERS_PATH=File.join(Rails.root,'lib/assets/ml_members.csv')

    puts "Load CSV..."
    ml_list=CSV.parse(File.read(CSV_ML_LIST_PATH),headers: true)
    ml_members=CSV.parse(File.read(CSV_ML_MEMBERS_PATH),headers: true)
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

    puts "Load ML members..."

    members_count = ml_members.count
    members_imported = 0

    ml_members.each do |ml_member_row|
      puts members_imported.to_s + " / " + members_count.to_s + " | "+ (members_imported/(members_count+1)*100).to_s + " | " + ml_member_row["list_email"] + " " + ml_member_row["member_email"]
      ml=Ml::List.find_by(email: ml_member_row["list_email"])
      ml.add_email(ml_member_row["member_email"])

      members_imported +=1

    end

    puts "Done! YOU ROCK!"

  end
end
