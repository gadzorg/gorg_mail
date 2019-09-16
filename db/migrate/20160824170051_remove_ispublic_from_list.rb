class RemoveIspublicFromList < ActiveRecord::Migration[4.2]
  def change
    remove_column :ml_lists, :is_public
  end
end
