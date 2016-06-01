module ResourceHelper
  def address(resource)
    address_part = [
      resource.facility_address.titleize,
      resource.facility_city.titleize,
      resource.facility_state
    ].join(', ')

    "#{address_part} #{resource.facility_zip}"
  end
end
