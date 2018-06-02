class AddContactInfoToCommonApplication < ActiveRecord::Migration[5.1]
  def change
    add_column :common_applications, :phone_number, :string
    add_column :common_applications, :sms_phone_number, :string

    add_column :common_applications, :sms_consented, :integer
    add_column :common_applications, :email_consented, :integer
    change_column_default :common_applications, :sms_consented, from: nil, to: 0
    change_column_default :common_applications, :email_consented, from: nil, to: 0
  end
end
