class CreateExpensesHouseholdMembers < ActiveRecord::Migration[5.1]
  def change
    safety_assured do
      create_table :expenses_household_members, id: false do |t|
        t.belongs_to :expense, index: true
        t.belongs_to :household_member, index: true
      end
    end
  end
end
