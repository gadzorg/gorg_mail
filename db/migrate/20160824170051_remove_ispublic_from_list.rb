class RemoveIspublicFromList < ActiveRecord::Migration
  def change
    remove_column :ml_lists, :is_public
  end
end
