class RemoveEmploymentFieldsForMedicaidApplications < ActiveRecord::Migration[5.1]
  def change
    safety_assured do
      remove_column :members, :employed_employer_names, :string, default: [], array: true
      remove_column :members, :employed_pay_quantities, :string, default: [], array: true
      remove_column :members, :employed_payment_frequency, :string, default: [], array: true
    end
  end
end
