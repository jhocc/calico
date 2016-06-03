class FosterFamilyAgenciesController < ApplicationController
  before_action :authenticate_user!

  def index
    @foster_family_agencies = service.find_by_zip_code(current_user.primary_address.zip_code)
  end

  def show
    @foster_family_agency = service.find(params[:id])
    @associated_case_workers = User.case_workers.where(foster_family_agency_number: params[:id])
  end

  def service
    @service ||= FosterFamilyAgencyService.new
  end
end