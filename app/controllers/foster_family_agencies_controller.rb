class FosterFamilyAgenciesController < ApplicationController
  before_action :authenticate_user!

  def index
    @current_zip_code = params[:zip_code] || current_user.primary_address.zip_code
    @foster_family_agencies = service.find_by_zip_code(@current_zip_code)
    flash.now[:notice] = 'There are no foster family agencies in your zip code' if @foster_family_agencies.empty?
  end

  def show
    @foster_family_agency = service.find(params[:id])
    @associated_case_workers = User.case_workers.where(foster_family_agency_number: params[:id])
  end

  def service
    @service ||= FosterFamilyAgencyService.new
  end
end
