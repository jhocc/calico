class Address < ActiveRecord::Base
  belongs_to :user

  validates :zip_code, presence: true
end
