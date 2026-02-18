class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :full_name
      t.string :email
      t.string :password
      t.integer :manager_id
      t.string :roles
      t.integer :status

      t.timestamps
    end
  end
end
