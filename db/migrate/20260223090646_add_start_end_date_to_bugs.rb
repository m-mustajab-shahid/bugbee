class AddStartEndDateToBugs < ActiveRecord::Migration[8.1]
  def change
    add_column :bugs, :start_date, :date
    add_column :bugs, :end_date, :date
  end
end
