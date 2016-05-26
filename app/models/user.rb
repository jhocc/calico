class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :timeoutable

  has_many :addresses

  def primary_address
    addresses.order(created_at: :desc).first
  end
end
