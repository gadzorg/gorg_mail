class AddPrimaryaliasToEmailSourceAccount < ActiveRecord::Migration[4.2]
  def change
    add_column :email_source_accounts, :primary, :boolean
  end
end
