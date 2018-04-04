class AddMedicalBillAttributes < ActiveRecord::Migration[5.1]
  def change
    add_column :application_navigators, :anyone_medical_bills, :boolean
    change_column_default :application_navigators, :anyone_medical_bills, from: nil, to: true

    add_column :household_members, :medical_bills, :integer
    change_column_default :household_members, :medical_bills, from: nil, to: 0
  end
end
