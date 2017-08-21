class AddDefaultTrueToMailingAddressSameAsResidentialAddress < ActiveRecord::Migration[5.1]
  def change
    change_column_default :snap_applications, :mailing_address_same_as_residential_address, true
  end
end
