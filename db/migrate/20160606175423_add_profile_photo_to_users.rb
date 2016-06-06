class AddProfilePhotoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :profile_photo, :string, comment: 'Photo displayed in user profile and chat'
  end
end
