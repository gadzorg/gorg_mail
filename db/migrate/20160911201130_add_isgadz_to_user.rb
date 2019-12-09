class AddIsgadzToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :is_gadz, :boolean
  end
end
