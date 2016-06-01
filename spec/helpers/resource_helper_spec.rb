require 'rails_helper'

RSpec.describe ResourceHelper, type: :helper do
  it 'display full resource address with city name, state name and zip code' do
    resource = double(:resource,
      facility_address: '71 W 23th Street',
      facility_city: 'New York',
      facility_state: 'NY',
      facility_zip: '10010'
    )
    expect(helper.address(resource)).to eq "#{resource.facility_address}, #{resource.facility_city}, #{resource.facility_state} #{resource.facility_zip}"
  end

  it 'display resource address with titleizes address name and city name' do
    resource = double(:resource,
      facility_address: '557 STATE ST',
      facility_city: 'UKIAH',
      facility_state: 'CA',
      facility_zip: '95482'
    )
    expect(helper.address(resource)).to eq '557 State St, Ukiah, CA 95482'
  end
end
