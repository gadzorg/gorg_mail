class AddImelaviMigrations < ActiveRecord::Migration[4.2]
  def change
    create_table :postfix_blacklists do |t|
      t.string :email
      t.string :reject_text

      t.timestamps null: false
    end

    create_table :email_redirect_accounts do |t|
      t.integer :uid
      t.string :redirect
      t.string :rewrite
      t.string :type_redir
      t.string :action
      t.date :broken_date
      t.integer :broken_level
      t.date :last
      t.string :flag
      t.integer :allow_rewrite
      t.string :srs_rewrite
      t.string :confirmation_token
      t.boolean :confirmed, :default => true

      t.timestamps null: false
    end

    create_table :email_virtuals do |t|
      t.string :email
      t.integer :domain
      t.string :redirect
      t.integer :type_alias
      t.date :expire
      t.integer :srs_rewrite

      t.timestamps null: false
    end

    create_table :email_source_accounts do |t|
      t.string :email
      t.integer :uid
      t.integer :type_source
      t.string :flag #type SET en sql
      t.date :expire

      t.timestamps null: false
    end

    create_table :email_virtual_domains do |t|
      #t.integer :id attention cette table n'utilise pas les id de la table de platal
      t.string :name
      t.integer :aliasing

      t.timestamps null: false
    end

    create_table :aliases do |t|

      t.string :email
      t.string :redirect

      t.timestamps null: false
    end

    add_reference :email_source_accounts, :user, index: true
    add_reference :email_redirect_accounts, :user, index: true
    add_reference :email_source_accounts, :email_virtual_domain, index: true, foreign_key: true

    add_index :email_redirect_accounts, :confirmation_token, unique: true

  end
end
