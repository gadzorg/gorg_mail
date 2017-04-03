class AddCommentariesToPostfixBlacklists < ActiveRecord::Migration
  def change
    add_column :postfix_blacklists, :commentary, :string
  end
end
