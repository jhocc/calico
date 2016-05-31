class ResourcesController < ApplicationController
  before_action :authenticate_user!

  DATA_SET_URL = "https://chhs.data.ca.gov/resource/v9bn-m9p9.json".freeze

  def index
    query = <<-QUERY
      facility_status = 'LICENSED' AND
      facility_zip = '#{current_user.primary_address.zip_code}' AND
      (facility_type = 'FOSTER FAMILY AGENCY' OR facility_type = 'FOSTER FAMILY AGENCY SUB')
    QUERY
    @resources = client.get(DATA_SET_URL, '$where' => query)
  end

  def client
    @client ||= ::SODA::Client.new
  end
end
