namespace :import_ml do
  desc "TODO"
  task import_csv: :environment do
    require 'csv'

    CSV_ML_LIST_PATH=File.join(Rails.root,'lib/assets/ml_list.csv')
    CSV_ML_MEMBERS_PATH=File.join(Rails.root,'lib/assets/ml_members.csv')

    ml_list=CSV.parse(File.read(CSV_ML_LIST_PATH),headers: true)
    ml_members=CSV.parse(File.read(CSV_ML_MEMBERS_PATH),headers: true)

    ml_list.each do |ml_row|
      Ml::List.create(
          name:ml_row["name"],
          email:ml_row["email"],
          description:ml_row["description"],
          aliases:ml_row["aliases"], # alias séparés par des virgules
          diffusion_policy:ml_row["diffusion_policy"], # open closed moderated
          messsage_header:ml_row["messsage_header"],
          message_footer:ml_row["message_footer"],
          is_archived: true,
          custom_reply_to: ml_row["custom_reply_to"],
          default_message_deny_notification_text: nil,
          msg_welcome:ml_row["msg_welcome"],
          msg_goodbye:ml_row["msg_goodbye"],
          message_max_bytes_size:ml_row["message_max_bytes_size"],
          inscription_policy:ml_row["inscription_policy"], #open conditional_gadz closed in_group
      )
    end

    ml_members.each do |ml_member_row|

      ml=Ml::List.find_by(email: ml_member_row["list_email"])
      ml.add_email(ml_member_row["member_email"])
    end

  end
end
