class AddMailingAddressSameAsResidentalAddressToMedicaidApplication < ActiveRecord::Migration[5.1]
  def up
    add_column :medicaid_applications, :mailing_address_same_as_residential_address, :boolean
    change_column_default :medicaid_applications, :mailing_address_same_as_residential_address, true
  end

  def down
    remove_column :medicaid_applications, :mailing_address_same_as_residential_address
  end
end
