class CreateHouseholdMembersVehicles < ActiveRecord::Migration[5.1]
  def change
    safety_assured do
      create_table :household_members_vehicles, id: false do |t|
        t.belongs_to :vehicle, index: true
        t.belongs_to :household_member, index: true
      end
    end
  end
end
