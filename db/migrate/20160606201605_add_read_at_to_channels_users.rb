class AddReadAtToChannelsUsers < ActiveRecord::Migration
  def change
    add_column :channels_users, :read_at, :datetime
  end
end
