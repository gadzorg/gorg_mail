class AddGadzCentreAndGadzPromsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :gadz_centre_principal, :string
    add_column :users, :gadz_proms_principale, :string
  end
end
