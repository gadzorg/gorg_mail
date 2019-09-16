class AddDomainToAlias < ActiveRecord::Migration[4.2]
  def change
    add_column :aliases, :email_virtual_domain_id, :string
    add_column :aliases, :expire, :date
    add_column :aliases, :srs_rewrite, :integer
  end
end
