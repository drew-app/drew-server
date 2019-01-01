class CreateTrackerRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :tracker_records do |t|
      t.references :tracker, foreign_key: true

      t.timestamps
    end
  end
end
