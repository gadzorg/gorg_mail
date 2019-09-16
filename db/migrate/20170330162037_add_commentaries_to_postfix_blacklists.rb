class AddCommentariesToPostfixBlacklists < ActiveRecord::Migration[4.2]
  def change
    add_column :postfix_blacklists, :commentary, :string
  end
end
