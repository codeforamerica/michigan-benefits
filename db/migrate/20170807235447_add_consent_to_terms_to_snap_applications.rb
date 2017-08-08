class AddConsentToTermsToSnapApplications < ActiveRecord::Migration[5.1]
  def change
    add_column :snap_applications, :consent_to_terms, :boolean
  end
end
