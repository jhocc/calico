module ResourceHelper
  def address(resource)
    [
      resource.facility_address,
      resource.facility_city,
      resource.facility_state
    ].join(', ') + ' ' + resource.facility_zip
  end
end
