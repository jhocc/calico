class Channel < ActiveRecord::Base
  has_many :channels_users
  has_many :users, through: :channels_users
  has_many :messages
end
