class AddTaxRelationshipToMember < ActiveRecord::Migration[5.1]
  def change
    add_column :members, :tax_relationship, :string
  end
end
