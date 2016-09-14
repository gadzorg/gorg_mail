class AddIsgadzToUser < ActiveRecord::Migration
  def change
    add_column :users, :is_gadz, :boolean
  end
end
