class AddContactFieldsToMedicaidApplications < ActiveRecord::Migration[5.1]
  class MedicaidApplication < ActiveRecord::Base
  end

  def up
    add_column :medicaid_applications, :phone_number, :string
    add_column :medicaid_applications, :sms_phone_number, :string
    add_column :medicaid_applications, :email, :string

    add_column :medicaid_applications, :sms_consented, :boolean
    change_column_default :medicaid_applications, :sms_consented, true
    MedicaidApplication.in_batches.update_all sms_consented: true
    add_column :medicaid_applications, :encrypted_ssn, :string
    add_column :medicaid_applications, :encrypted_ssn_iv, :string
    add_column :medicaid_applications, :birthday, :datetime
  end

  def down
    remove_column :medicaid_applications, :phone_number, :string
    remove_column :medicaid_applications, :sms_phone_number, :string
    remove_column :medicaid_applications, :email, :string
    remove_column :medicaid_applications, :sms_consented, :boolean
    remove_column :medicaid_applications, :encrypted_ssn, :string
    remove_column :medicaid_applications, :encrypted_ssn_iv, :string
    remove_column :medicaid_applications, :birthday, :datetime
  end
end
