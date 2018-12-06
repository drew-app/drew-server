class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
      t.string :name
      t.references :user

      t.timestamps
    end

    create_join_table :tags, :tasks

    add_index :tags, [:user_id, :name], unique: true
    add_foreign_key :tags, :users
  end
end
