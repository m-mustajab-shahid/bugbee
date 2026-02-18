class AddProfilePhotoToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :profile_photo, :string
  end
end
