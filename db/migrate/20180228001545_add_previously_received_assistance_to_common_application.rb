class AddPreviouslyReceivedAssistanceToCommonApplication < ActiveRecord::Migration[5.1]
  def change
    add_column :common_applications, :previously_received_assistance, :integer
    change_column_null :common_applications, :previously_received_assistance, false, 0
    change_column_default :common_applications, :previously_received_assistance, from: nil, to: 0

    change_column_null :household_members, :sex, false, 0
    change_column_default :household_members, :sex, from: nil, to: 0
  end
end
