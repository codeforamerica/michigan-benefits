class AddAdditionalIncomeFieldsToSnapApplications < ActiveRecord::Migration[5.1]
  def change
    add_column :snap_applications, :income_child_support, :string
    add_column :snap_applications, :income_foster_care, :string
    add_column :snap_applications, :income_other, :string
    add_column :snap_applications, :income_pension, :string
    add_column :snap_applications, :income_social_security, :string
    add_column :snap_applications, :income_ssi_or_disability, :string
    add_column :snap_applications, :income_unemployment_insurance, :string
    add_column :snap_applications, :income_workers_compensation, :string
  end
end
