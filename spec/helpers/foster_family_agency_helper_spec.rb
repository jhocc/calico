require 'rails_helper'

RSpec.describe FosterFamilyAgencyHelper, type: :helper do
  it 'display full foster_family_agency address with city name, state name and zip code' do
    ffa = double(:foster_family_agency,
      facility_address: '71 W 23th Street',
      facility_city: 'New York',
      facility_state: 'NY',
      facility_zip: '10010'
    )
    expect(helper.address(ffa)).to eq "#{ffa.facility_address}, #{ffa.facility_city}, #{ffa.facility_state} #{ffa.facility_zip}"
  end

  it 'display foster_family_agency address with titleizes address name and city name' do
    ffa = double(:foster_family_agency,
      facility_address: '557 STATE ST',
      facility_city: 'UKIAH',
      facility_state: 'CA',
      facility_zip: '95482'
    )
    expect(helper.address(ffa)).to eq '557 State St, Ukiah, CA 95482'
  end
end
