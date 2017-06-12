class CreateMailTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.string :token
      t.references :tokenable, polymorphic: true
      t.string :scope
      t.datetime :expires_at
      t.datetime :used_at
      t.string :data

      t.timestamps null: false
    end

    add_index :tokens, :token, unique: true
  end
end
