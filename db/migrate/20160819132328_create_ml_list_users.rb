class CreateMlListUsers < ActiveRecord::Migration
  def change
    create_table :ml_list_users do |t|
      t.integer :user_id
      t.integer :list_id
      t.boolean :is_ban
      t.boolean :pending
      t.boolean :is_on_white_list
      t.boolean :is_moderator
      t.boolean :is_admin

      t.timestamps null: false
    end
  end
end
