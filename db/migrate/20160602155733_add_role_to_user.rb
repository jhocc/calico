class AddRoleToUser < ActiveRecord::Migration
  def change
    add_column :users, :role, :string,
      default: Role::PUBLIC,
      comment: 'user role for authentication'
  end
end
