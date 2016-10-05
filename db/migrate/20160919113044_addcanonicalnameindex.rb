class Addcanonicalnameindex < ActiveRecord::Migration
  def change
    add_index :users, :canonical_name

  end
end
