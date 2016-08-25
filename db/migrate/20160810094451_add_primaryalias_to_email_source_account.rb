class AddPrimaryaliasToEmailSourceAccount < ActiveRecord::Migration
  def change
    add_column :email_source_accounts, :primary, :boolean
  end
end
