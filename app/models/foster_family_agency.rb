class FosterFamilyAgency
  attr_reader :facility_type,
    :facility_address,
    :facility_state,
    :facility_capacity,
    :facility_city,
    :facility_telephone_number,
    :facility_name,
    :facility_administrator,
    :facility_status,
    :facility_number,
    :facility_zip

  def initialize(params)
    @facility_address = params.facility_address
    @facility_state = params.facility_state
    @facility_capacity = params.facility_capacity
    @facility_city = params.facility_city
    @facility_telephone_number = params.facility_telephone_number
    @facility_name = params.facility_name
    @facility_administrator = params.facility_administrator
    @facility_status = params.facility_status
    @facility_number = params.facility_number
    @facility_zip = params.facility_zip
  end
end
