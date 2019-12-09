class CreateMlLists < ActiveRecord::Migration[4.2]
  def change
    create_table :ml_lists do |t|
      t.string :name
      t.string :email
      t.string :description
      t.string :aliases
      t.string :diffusion_policy
      t.integer :inscription_policy_id
      t.boolean :is_public
      t.string :messsage_header
      t.string :message_footer
      t.boolean :is_archived
      t.string :custom_reply_to
      t.string :default_message_deny_notification_text
      t.string :msg_welcome
      t.string :msg_goodbye
      t.boolean :is_archived
      t.integer :message_max_bytes_size

      t.timestamps null: false
    end
  end
end
