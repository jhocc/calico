class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :timeoutable

  has_many :channels_users
  has_many :channels, through: :channels_users
  has_many :addresses
  accepts_nested_attributes_for :addresses

  def primary_address
    addresses.order(created_at: :desc).first
  end

  after_create :create_initial_channel, unless: Proc.new { self.email == 'help_user@casecommons.org' }

  def create_initial_channel
    help_user = User.find_or_initialize_by(email: 'help_user@casecommons.org') do |user|
      user.first_name = 'Help'
      user.last_name = 'User'
      user.password = SecureRandom.uuid
    end
    channels.build(users: [help_user, self]).save!
  end
end
