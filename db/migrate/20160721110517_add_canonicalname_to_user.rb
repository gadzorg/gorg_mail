class AddCanonicalnameToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :canonical_name, :string
  end
end
