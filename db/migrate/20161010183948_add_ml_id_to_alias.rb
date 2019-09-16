class AddMlIdToAlias < ActiveRecord::Migration[4.2]
  def change
    add_column :aliases, :list_id, :integer
    add_index :aliases, :list_id

  end
end
