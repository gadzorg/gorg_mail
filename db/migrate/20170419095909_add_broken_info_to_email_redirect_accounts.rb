class AddBrokenInfoToEmailRedirectAccounts < ActiveRecord::Migration[4.2]
  def change
    add_column :email_redirect_accounts, :broken_info, :string
  end
end
