class AddFlintWaterCrisisToMedicaidApplications < ActiveRecord::Migration[5.1]
  def change
    add_column :medicaid_applications, :flint_water_crisis, :boolean
  end
end
