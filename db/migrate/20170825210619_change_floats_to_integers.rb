class ChangeFloatsToIntegers < ActiveRecord::Migration[5.1]
  def up
    change_column :members, :employed_pay_quantity, :integer
    change_column :members, :self_employed_monthly_income, :integer
    change_column :snap_applications, :total_money, :integer
    change_column :snap_applications, :income_child_support, :integer
    change_column :snap_applications, :income_foster_care, :integer
    change_column :snap_applications, :income_other, :integer
    change_column :snap_applications, :income_pension, :integer
    change_column :snap_applications, :income_social_security, :integer
    change_column :snap_applications, :income_ssi_or_disability, :integer
    change_column :snap_applications, :income_unemployment_insurance, :integer
    change_column :snap_applications, :income_workers_compensation, :integer
  end

  def down
    change_column :members, :employed_pay_quantity, :float
    change_column :members, :self_employed_monthly_income, :float
    change_column :snap_applications, :total_money, :float
    change_column :snap_applications, :income_child_support, :float
    change_column :snap_applications, :income_foster_care, :float
    change_column :snap_applications, :income_other, :float
    change_column :snap_applications, :income_pension, :float
    change_column :snap_applications, :income_social_security, :float
    change_column :snap_applications, :income_ssi_or_disability, :float
    change_column :snap_applications, :income_unemployment_insurance, :float
    change_column :snap_applications, :income_workers_compensation, :float
  end
end
