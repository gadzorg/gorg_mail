class AddChangeColumnNullToUserEmail < ActiveRecord::Migration
  def self.up
    change_column :users, :email, :string, :null => true
    change_column :users, :hruid, :string, :null => false
    remove_index :users, :email
  end

  def self.down
    change_column :users, :hruid, :string, :null => true
    change_column :users, :email, :string, :null => false
    add_index :users, :email,                unique: true
  end

end
