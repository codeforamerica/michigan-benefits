class RenameNewMomInMedicaidApplication < ActiveRecord::Migration[5.1]
  def up
    add_column :medicaid_applications, :anyone_new_mom, :boolean

    safety_assured do
      execute "UPDATE medicaid_applications SET anyone_new_mom=new_mom"
      remove_column :medicaid_applications, :new_mom
    end
  end

  def down
    add_column :medicaid_applications, :new_mom, :boolean

    safety_assured do
      execute "UPDATE medicaid_applications SET new_mom=anyone_new_mom"
      remove_column :medicaid_applications, :anyone_new_mom
    end
  end
end
