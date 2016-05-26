class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.belongs_to :user, index:true
      t.text :street_address
      t.text :zip_code
      t.text :city
      t.text :state
      t.text :country
      t.timestamps null: false
    end
  end
end
