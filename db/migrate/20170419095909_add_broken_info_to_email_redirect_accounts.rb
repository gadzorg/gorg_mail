class AddBrokenInfoToEmailRedirectAccounts < ActiveRecord::Migration
  def change
    add_column :email_redirect_accounts, :broken_info, :string
  end
end
