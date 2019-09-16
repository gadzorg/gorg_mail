class DropEmailvirtual < ActiveRecord::Migration[4.2]
  def change
    drop_table :email_virtuals
  end
end
