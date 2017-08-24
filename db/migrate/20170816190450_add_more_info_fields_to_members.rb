class AddMoreInfoFieldsToMembers < ActiveRecord::Migration[5.1]
  def change
    add_column :members, :citizen, :boolean
    add_column :members, :disabled, :boolean
    add_column :members, :new_mom, :boolean
    add_column :members, :in_college, :boolean
    add_column :members, :living_elsewhere, :boolean
  end
end
