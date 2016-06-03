require 'rails_helper'

describe FosterFamilyAgencyService do
  let(:client) { double(:client) }
  let(:service) { described_class.new(client) }

  describe '#all' do
    let(:foster_family_agencies) { [double(:foster_family_agency), double(:foster_family_agency) ]}

    it 'returns licensed foster family agencies' do
      expect(client).to receive(:get).with(
        anything,
        hash_including({
          '$where' => include("facility_status = 'LICENSED'")
        })
      ).and_return(foster_family_agencies)

      expect(service.all).to eq(foster_family_agencies)
    end

    it 'returns foster family and sub agencies' do
      expect(client).to receive(:get).with(
        anything,
        hash_including({
          '$where' => include("(facility_type = 'FOSTER FAMILY AGENCY' OR facility_type = 'FOSTER FAMILY AGENCY SUB')")
        })
      ).and_return(foster_family_agencies)

      expect(service.all).to eq(foster_family_agencies)
    end
  end

  describe '#find_by_zip_code' do
    let(:foster_family_agencies) { [double(:foster_family_agency), double(:foster_family_agency) ]}

    it 'returns foster family agencies by zip code' do
      expect(client).to receive(:get)
        .with(
          described_class::DATA_SET_URL,
          hash_including({
            '$where' => include("facility_zip = '90008'")
          })
        ).and_return(foster_family_agencies)

      expect(service.find_by_zip_code('90008'))
        .to eq(foster_family_agencies)
    end

    it 'returns licensed foster family agencies' do
      expect(client).to receive(:get).with(
        anything,
        hash_including({
          '$where' => include("facility_status = 'LICENSED'")
        })
      ).and_return(foster_family_agencies)

      expect(service.find_by_zip_code('90008'))
        .to eq(foster_family_agencies)
    end

    it 'returns foster family and sub agencies' do
      expect(client).to receive(:get).with(
        anything,
        hash_including({
          '$where' => include("(facility_type = 'FOSTER FAMILY AGENCY' OR facility_type = 'FOSTER FAMILY AGENCY SUB')")
        })
      ).and_return(foster_family_agencies)

      expect(service.find_by_zip_code('90008'))
        .to eq(foster_family_agencies)
    end
  end

  describe '#find' do
    let(:foster_family_agency) { double(:foster_family_agency) }

    it 'returns foster family agency by id (facility_number)' do
      foster_family_agency = double(:foster_family_agency)
      expect(client).to receive(:get).with(
        described_class::DATA_SET_URL,
        { 'facility_number' => '10010010' }
      ).and_return([foster_family_agency])

      expect(service.find('10010010'))
        .to eq(foster_family_agency)
    end
  end
end
