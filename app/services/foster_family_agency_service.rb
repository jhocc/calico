class FosterFamilyAgencyService
  DATA_SET_URL = "https://chhs.data.ca.gov/resource/v9bn-m9p9.json".freeze

  attr_reader :client

  def initialize(client=SODA::Client.new)
    @client = client
  end

  def all
    query = <<-QUERY
      facility_status = 'LICENSED' AND
      (facility_type = 'FOSTER FAMILY AGENCY' OR facility_type = 'FOSTER FAMILY AGENCY SUB')
    QUERY

    client.get(DATA_SET_URL, '$where' => query)
  end

  def find_by_zip_code(zip_code)
    query = <<-QUERY
      facility_status = 'LICENSED' AND
      facility_zip = '#{zip_code}' AND
      (facility_type = 'FOSTER FAMILY AGENCY' OR facility_type = 'FOSTER FAMILY AGENCY SUB')
    QUERY
    client.get(DATA_SET_URL, '$where' => query)
  end

  def find(id)
    client.get(DATA_SET_URL, 'facility_number' => id).first
  end
end
