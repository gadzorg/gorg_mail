class AddTypeToAlias < ActiveRecord::Migration
  def change
    add_column :aliases, :alias_type, :string
  end
end
