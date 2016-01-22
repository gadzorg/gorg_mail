class AddLastSyncToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_gram_sync_at, :datetime
  end
end
