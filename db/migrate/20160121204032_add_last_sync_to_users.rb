class AddLastSyncToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :last_gram_sync_at, :datetime
  end
end
