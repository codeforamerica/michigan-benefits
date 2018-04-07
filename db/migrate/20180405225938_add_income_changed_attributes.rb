class AddIncomeChangedAttributes < ActiveRecord::Migration[5.1]
  def change
    add_column :common_applications, :income_changed, :integer
    change_column_default :common_applications, :income_changed, from: nil, to: 0

    add_column :common_applications, :income_changed_explanation, :text
  end
end
