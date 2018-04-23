class AddAmountThresholdToApplication < ActiveRecord::Migration[5.1]
  def change
    add_column :common_applications, :less_than_threshold_in_accounts, :integer
    change_column_default :common_applications, :less_than_threshold_in_accounts, from: nil, to: 0
  end
end
