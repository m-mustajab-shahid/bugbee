class AddDeletedAtToBugs < ActiveRecord::Migration[8.1]
  def change
    add_column :bugs, :deleted_at, :datetime
    add_index :bugs, :deleted_at
  end
end
