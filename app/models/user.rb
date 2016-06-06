class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :timeoutable

  FEEDBACK_USER_EMAIL='calico_feedback_user@casecommons.org'

  has_many :channels_users
  has_many :channels, through: :channels_users
  has_many :addresses
  accepts_nested_attributes_for :addresses
  validates :first_name, presence: true
  validates :last_name, presence: true

  scope :case_workers, -> { where(role: 'case_worker') }

  def primary_address
    addresses.order(created_at: :desc).first
  end

  def is_feedback_user?
    email == FEEDBACK_USER_EMAIL
  end
end
