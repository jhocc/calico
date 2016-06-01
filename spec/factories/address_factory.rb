FactoryGirl.define do
  factory :address do
    street_address { Faker::Address.street_address }
    city { "#{Faker::Address.city_suffix} #{Faker::Address.city_prefix}" }
    state { Faker::Address.state_abbr }
    country { Faker::Address.country }
    zip_code { Faker::Address.zip_code.split('-').first }
  end
end
