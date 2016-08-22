class AddInscriptionpolicyToMlList < ActiveRecord::Migration
  def change
    add_column :ml_lists, :inscription_policy, :string
    add_column :ml_lists, :group_uuid, :string
    remove_column :ml_lists, :inscription_policy_id
  end
end
