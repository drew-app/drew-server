class AddStartedFlagToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :started, :boolean
  end
end
