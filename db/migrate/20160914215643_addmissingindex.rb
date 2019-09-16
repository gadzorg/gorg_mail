class Addmissingindex < ActiveRecord::Migration[4.2]
  def change
    add_index :users, :uuid,                unique: true
    add_index :users, :hruid,                unique: true
    add_index :users, :is_gadz

    add_index :ml_external_emails, :email
    add_index :ml_external_emails, :list_id

    add_index :aliases, :email
    add_index :aliases, :redirect
    add_index :aliases, :email_virtual_domain_id

    add_index :email_redirect_accounts, :redirect
    add_index :email_redirect_accounts, :flag
    add_index :email_redirect_accounts, :type_redir

    add_index :email_source_accounts, :email
    add_index :email_source_accounts, :flag
    add_index :email_source_accounts, :primary

    add_index :ml_lists, :email
    add_index :ml_lists, :group_uuid

    add_index :postfix_blacklists, :email
  end
end
