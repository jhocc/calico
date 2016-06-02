class AddFosterFamilyAgencyNumberToUser < ActiveRecord::Migration
  def change
    add_column :users, :foster_family_agency_number, :integer,
      comment: 'facility number from api'
    add_index :users, :foster_family_agency_number
  end
end
