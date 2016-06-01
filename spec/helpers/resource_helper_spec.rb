require 'rails_helper'

RSpec.describe ResourceHelper, type: :helper do
  it 'display full resource address with city name, state name and zip code' do
    resource = double(:resource,
      facility_address: '71 W 23th street',
      facility_city: 'New York',
      facility_state: 'NY',
      facility_zip: '10010'
    )
    expect(helper.address(resource)).to eq "#{resource.facility_address}, #{resource.facility_city}, #{resource.facility_state} #{resource.facility_zip}"
  end
end
