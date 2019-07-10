class AddDefaultsAndRenameTaskAttributes < ActiveRecord::Migration[5.2]
  def change
    change_column_default :tasks, :done, from: nil, to: false
    change_column_default :tasks, :started, from: nil, to: false

    rename_column :tasks, :started, :focused
  end
end
