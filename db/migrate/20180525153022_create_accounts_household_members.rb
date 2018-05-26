class CreateAccountsHouseholdMembers < ActiveRecord::Migration[5.1]
  def change
    safety_assured do
      create_table :accounts_household_members, id: false do |t|
        t.belongs_to :account, index: true
        t.belongs_to :household_member, index: true
      end
    end
  end
end
