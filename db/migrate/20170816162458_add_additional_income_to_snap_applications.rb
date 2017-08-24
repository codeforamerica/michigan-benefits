class AddAdditionalIncomeToSnapApplications < ActiveRecord::Migration[5.1]
  def change
    add_column(
      :snap_applications,
      :additional_income,
      :text,
      array: true,
      default: [],
    )
  end
end
