class AddStudentAttributesToNavigatorAndMember < ActiveRecord::Migration[5.1]
  def change
    add_column :application_navigators, :anyone_student, :boolean
    change_column_default :application_navigators, :anyone_student, from: nil, to: true

    add_column :household_members, :student, :integer
    change_column_default :household_members, :student, from: nil, to: 0
  end
end
