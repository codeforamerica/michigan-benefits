class AddIncomeFieldsToApp < ActiveRecord::Migration[5.0]
  def change
    add_column :apps, :income_unemployment, :integer
    add_column :apps, :income_ssi, :integer
    add_column :apps, :income_workers_comp, :integer
    add_column :apps, :income_pension, :integer
    add_column :apps, :income_social_security, :integer
    add_column :apps, :income_foster_care, :integer
    add_column :apps, :income_other, :integer

    rename_column :apps, :child_support, :income_child_support
  end
end
