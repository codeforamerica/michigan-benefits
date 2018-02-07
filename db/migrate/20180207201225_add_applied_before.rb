class AddAppliedBefore < ActiveRecord::Migration[5.1]
  def change
    add_column :snap_applications, :applied_before, :integer
    change_column_default :snap_applications, :applied_before, from: nil, to: 0

    add_column :medicaid_applications, :applied_before, :integer
    change_column_default :medicaid_applications, :applied_before, from: nil, to: 0
  end
end
