class CreateTrackers < ActiveRecord::Migration[5.2]
  def change
    create_table :trackers do |t|
      t.string :title
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
