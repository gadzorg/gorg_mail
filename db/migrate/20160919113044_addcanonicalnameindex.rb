class Addcanonicalnameindex < ActiveRecord::Migration[4.2]
  def change
    add_index :users, :canonical_name

  end
end
