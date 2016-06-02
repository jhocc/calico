class CreateChannelsUsers < ActiveRecord::Migration
  def change
    create_table :channels_users do |t|
      t.belongs_to :user, index: true, null: false
      t.belongs_to :channel, index: true, null: false
      t.timestamps null: false
    end
  end
end
