class AddMailingAddressSameAsResidentialAddressToSnapApplications < ActiveRecord::Migration[5.1]
  def change
    add_column :snap_applications, :mailing_address_same_as_residential_address, :boolean
  end
end
