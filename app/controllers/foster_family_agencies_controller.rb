class FosterFamilyAgenciesController < ApplicationController
  before_action :authenticate_user!

  DATA_SET_URL = "https://chhs.data.ca.gov/resource/v9bn-m9p9.json".freeze

  def index
    query = <<-QUERY
      facility_status = 'LICENSED' AND
      facility_zip = '#{current_user.primary_address.zip_code}' AND
      (facility_type = 'FOSTER FAMILY AGENCY' OR facility_type = 'FOSTER FAMILY AGENCY SUB')
    QUERY
    @foster_family_agencies = client.get(DATA_SET_URL, '$where' => query)
  end

  def show
    @foster_family_agency = client.get(DATA_SET_URL, 'facility_number' => params[:id]).first
  end

  def client
    @client ||= ::SODA::Client.new
  end
end
