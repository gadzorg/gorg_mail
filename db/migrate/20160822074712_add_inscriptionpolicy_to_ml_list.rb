class AddInscriptionpolicyToMlList < ActiveRecord::Migration[4.2]
  def change
    add_column :ml_lists, :inscription_policy, :string
    add_column :ml_lists, :group_uuid, :string
    remove_column :ml_lists, :inscription_policy_id
  end
end
