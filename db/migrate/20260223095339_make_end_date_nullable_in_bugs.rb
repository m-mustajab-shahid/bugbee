class MakeEndDateNullableInBugs < ActiveRecord::Migration[8.1]
  def change
    remove_column :bugs, :start_date
    remove_column :bugs, :end_date

    add_column :bugs, :start_date, :date, null: true
    add_column :bugs, :end_date, :date, null: true
  end
end
