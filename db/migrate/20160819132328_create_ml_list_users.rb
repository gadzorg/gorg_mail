class CreateMlListUsers < ActiveRecord::Migration
  def change
    create_table :ml_lists_users do |t|
      t.integer :user_id
      t.integer :list_id
      t.boolean :is_ban
      t.boolean :pending
      t.boolean :is_on_white_list
      t.boolean :is_moderator
      t.boolean :is_admin
      t.timestamps null: false
    end

    add_index :ml_lists_users, [:user_id, :list_id]
  end
end
