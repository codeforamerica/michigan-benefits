class RenameIncomesToAdditionalIncomes < ActiveRecord::Migration[5.1]
  def change
    safety_assured do
      rename_table :incomes, :additional_incomes
    end
  end
end
