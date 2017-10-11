class CreateMedicaidApplications < ActiveRecord::Migration[5.1]
  def change
    create_table :medicaid_applications do |t|
      t.boolean :michigan_resident, null: false

      t.timestamps
    end
  end
end
