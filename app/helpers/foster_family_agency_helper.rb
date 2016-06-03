module FosterFamilyAgencyHelper
  def address(foster_family_agency)
    address_part = [
      foster_family_agency.facility_address.titleize,
      foster_family_agency.facility_city.titleize,
      foster_family_agency.facility_state
    ].join(', ')

    "#{address_part} #{foster_family_agency.facility_zip}"
  end
end
