class ChangeStatusTypeInProjects < ActiveRecord::Migration[8.1]
  def change
    remove_column :projects, :status
    add_column :projects, :status, :string, default: "active"
  end
end
