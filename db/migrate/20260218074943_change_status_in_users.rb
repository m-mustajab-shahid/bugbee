class ChangeStatusInUsers < ActiveRecord::Migration[8.1]
  def change
    remove_column :users, :status, :integer
    add_column :users, :status, :boolean, default: true
  end
end
