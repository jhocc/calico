class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :timeoutable

  has_many :channels_users
  has_many :channels, through: :channels_users
  has_many :addresses
  accepts_nested_attributes_for :addresses

  scope :case_workers, -> { where(role: 'case_worker') }

  def primary_address
    addresses.order(created_at: :desc).first
  end
end
