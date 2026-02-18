class CreateBugs < ActiveRecord::Migration[8.1]
  def change
    create_table :bugs do |t|
      t.string :title
      t.text :description
      t.references :project, null: false, foreign_key: true
      t.string :priority
      t.string :severity
      t.text :step_to_reproduce
      t.text :expected_results
      t.text :actual_result
      t.string :attachment
      t.references :reporter, null: false, foreign_key: { to_table: :users }
      t.references :assignee, null: true, foreign_key: { to_table: :users }
      t.string :status

      t.timestamps
    end
  end
end
