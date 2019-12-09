class AddTypeToAlias < ActiveRecord::Migration[4.2]
  def change
    add_column :aliases, :alias_type, :string
  end
end
