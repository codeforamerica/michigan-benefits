class RemoveDefaultValueForMedicaidApplicationsMailingAddressSameAsResidential < ActiveRecord::Migration[5.1]
  def change
    change_column_default(
      :medicaid_applications,
      :mailing_address_same_as_residential_address,
      from: true,
      to: nil,
    )
  end
end
