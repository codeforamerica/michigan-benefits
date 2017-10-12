class AddInputFieldsToDatabase < ActiveRecord::Migration[5.1]
  def change
    add_column :medicaid_applications, :first_name, :string
    add_column :medicaid_applications, :last_name, :string
    add_column :medicaid_applications, :gender, :string

    add_column :medicaid_applications, :income_unemployment, :boolean
    add_column :medicaid_applications, :income_pension, :boolean
    add_column :medicaid_applications, :income_social_security, :boolean
    add_column :medicaid_applications, :income_retirement, :boolean
    add_column :medicaid_applications, :income_alimony, :boolean

    add_column :medicaid_applications, :filing_federal_taxes_next_year, :boolean
    add_column :medicaid_applications, :number_of_jobs, :string
    add_column :medicaid_applications, :self_employed, :boolean
  end
end
