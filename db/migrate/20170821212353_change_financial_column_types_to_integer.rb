class ChangeFinancialColumnTypesToInteger < ActiveRecord::Migration[5.1]
  def up
    change_column :members, :employed_hours_per_week, "integer USING CAST(employed_hours_per_week AS integer)"
    change_column :members, :employed_pay_quantity, "float USING CAST(employed_pay_quantity AS float)"
    change_column :members, :self_employed_monthly_income, "float USING CAST(employed_pay_quantity AS float)"
    change_column :snap_applications, :total_money, "float USING CAST(total_money AS float)"
    change_column :snap_applications, :income_child_support, "float USING CAST(income_child_support AS float)"
    change_column :snap_applications, :income_foster_care, "float USING CAST(income_foster_care AS float)"
    change_column :snap_applications, :income_other, "float USING CAST(income_other AS float)"
    change_column :snap_applications, :income_pension, "float USING CAST(income_pension AS float)"
    change_column :snap_applications, :income_social_security, "float USING CAST(income_social_security AS float)"
    change_column :snap_applications, :income_ssi_or_disability, "float USING CAST(income_ssi_or_disability AS float)"
    change_column :snap_applications, :income_unemployment_insurance, "float USING CAST(income_unemployment_insurance AS float)"
    change_column :snap_applications, :income_workers_compensation, "float USING CAST(income_workers_compensation AS float)"
  end

  def down
    change_column :members, :employed_hours_per_week, :string
    change_column :members, :employed_pay_quantity, :string
    change_column :members, :self_employed_monthly_income, :string
    change_column :snap_applications, :total_money, :string
    change_column :snap_applications, :income_child_support, :string
    change_column :snap_applications, :income_foster_care, :string
    change_column :snap_applications, :income_other, :string
    change_column :snap_applications, :income_pension, :string
    change_column :snap_applications, :income_social_security, :string
    change_column :snap_applications, :income_ssi_or_disability, :string
    change_column :snap_applications, :income_unemployment_insurance, :string
    change_column :snap_applications, :income_workers_compensation, :string
  end
end
