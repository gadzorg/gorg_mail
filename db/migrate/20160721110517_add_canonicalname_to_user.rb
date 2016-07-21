class AddCanonicalnameToUser < ActiveRecord::Migration
  def change
    add_column :users, :canonical_name, :string
  end
end
