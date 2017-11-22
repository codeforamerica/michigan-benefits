class RemoveBirthdayFromMedicaidApplications < ActiveRecord::Migration[5.1]
  def change
    safety_assured do
      remove_column :medicaid_applications, :birthday, :datetime
    end
  end
end
