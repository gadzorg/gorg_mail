class DropEmailvirtual < ActiveRecord::Migration
  def change
    drop_table :email_virtuals
  end
end
