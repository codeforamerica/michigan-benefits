class AddEmployerInformationToMembers < ActiveRecord::Migration[5.1]
  def up
    add_column :members, :employed_monthly_employer, :string, array: true
    add_column :members, :employed_payment_frequency, :string, array: true

    change_column_default :members, :employed_monthly_employer, []
    change_column_default :members, :employed_payment_frequency, []
  end

  def down
    remove_column :members, :employed_monthly_employer
    remove_column :members, :employed_payment_frequency
  end
end
