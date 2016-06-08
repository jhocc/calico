require 'factory_girl_rails'

namespace :calico do
  desc 'Create 3 case worker users for every foster family agency'
  task :create_case_worker_users => :environment do
    service = FosterFamilyAgencyService.new
    ff_agencies = service.all

    puts "Start creating case worker users for #{ff_agencies.size} foster family agencies..."

    count = 0
    ff_agencies.each do |ffa|
      case_workers_count = User.where(foster_family_agency_number: ffa.facility_number).count
      number_of_users_to_create = [3 - case_workers_count, 0].max

      number_of_users_to_create.times do
        first_name = Faker::Name.first_name
        last_name = Faker::Name.last_name
        email = "#{first_name}.#{last_name}@calicoapp.co"

        case_worker = FactoryGirl.create(
          :case_worker,
          email: email,
          first_name: first_name,
          last_name: last_name,
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

  task :update_example_case_worker_emails => :environment do
    puts "Updating case worker users email to <first_name>.<last_name>@calicoapp.co"
    count = 0

    User.where(role: Role::CASE_WORKER).find_each do |user|
      email = "#{user.first_name}.#{user.last_name}@calicoapp.co"
      if user.email != email.downcase && user.email != User::FEEDBACK_USER_EMAIL
        user.update_attributes(email: email)

        print '.'
        count += 1
      end
    end

    puts "\r\nUpdated #{count} case worker users email to <first_name>.<last_name>@calicoapp.co"
  end
end
