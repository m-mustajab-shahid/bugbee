class ChangeRolesToRoleInUsers < ActiveRecord::Migration[8.1]
  def change
    rename_column :users, :roles, :role
  end
end
