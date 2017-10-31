class AddConsentToTermsToMedicaidApplications < ActiveRecord::Migration[5.1]
  def change
    add_column :medicaid_applications, :consent_to_terms, :boolean
  end
end
