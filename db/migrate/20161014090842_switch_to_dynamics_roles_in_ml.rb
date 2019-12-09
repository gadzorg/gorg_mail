class SwitchToDynamicsRolesInMl < ActiveRecord::Migration[4.2]
  def change
    remove_column :ml_lists_users, :is_ban
    remove_column :ml_lists_users, :is_admin
    remove_column :ml_lists_users, :is_moderator
    remove_column :ml_lists_users, :pending

    add_column :ml_lists_users,:role, :integer, default: 2
  end
end
