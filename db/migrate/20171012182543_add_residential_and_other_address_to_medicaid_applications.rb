class AddResidentialAndOtherAddressToMedicaidApplications < ActiveRecord::Migration[5.1]
  def change
    add_column :medicaid_applications, :residential_street_address, :string
    add_column :medicaid_applications, :residential_city, :string
    add_column :medicaid_applications, :residential_zip, :string

    add_column :medicaid_applications, :mailing_street_address, :string
    add_column :medicaid_applications, :mailing_city, :string
    add_column :medicaid_applications, :mailing_zip, :string
  end
end
