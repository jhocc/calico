require 'factory_girl_rails'

namespace :calico do
  desc 'Create 3 case worker users for every foster family agency'
  task :create_case_worker_users => :environment do
    service = FosterFamilyAgencyService.new
    ff_agencies = service.all

    puts "Start creating case worker users for #{ff_agencies.size} foster family agencies..."

    count = 0
    ff_agencies.each do |ffa|
      3.times do
        case_worker = FactoryGirl.create(
          :case_worker,
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          foster_family_agency_number: ffa.facility_number,
          password: 'Calico2016!',
          password_confirmation: 'Calico2016!'
        )

        case_worker.addresses << Address.new({
          street_address: ffa.facility_address.titleize,
          zip_code: ffa.facility_zip,
          city: ffa.facility_city.titleize,
          state: ffa.facility_state,
        })

        print '.'
        count += 1
      end
    end

    puts "Created #{count} new case worker users for foster family agencies..."
  end
end
