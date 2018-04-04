class AddHealthcareEnrolledAttributes < ActiveRecord::Migration[5.1]
  def change
    add_column :application_navigators, :anyone_healthcare_enrolled, :boolean
    change_column_default :application_navigators, :anyone_healthcare_enrolled, from: nil, to: true

    add_column :household_members, :healthcare_enrolled, :integer
    change_column_default :household_members, :healthcare_enrolled, from: nil, to: 0
  end
end
