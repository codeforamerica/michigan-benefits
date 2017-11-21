class AddMembersCountColumnsToSnapApplicationsAndMedicaidApplications < ActiveRecord::Migration[5.1]
  def change
    add_column :snap_applications, :members_count, :integer
    add_column :medicaid_applications, :members_count, :integer
    change_column_default :snap_applications, :members_count, from: nil, to: 0
    change_column_default :medicaid_applications, :members_count, from: nil, to: 0
  end
end
