class RenameAnyoneIsInsured < ActiveRecord::Migration[5.1]
  def up
    add_column :medicaid_applications, :anyone_insured, :boolean
    add_column :members, :insured, :boolean
    change_column_default :medicaid_applications, :anyone_insured, false
    change_column_default :members, :insured, false

    safety_assured do
      execute "UPDATE medicaid_applications SET anyone_insured=anyone_is_insured"
      execute "UPDATE members SET insured=is_insured"
      remove_column :medicaid_applications, :anyone_is_insured
      remove_column :members, :is_insured
    end
  end

  def down
    add_column :medicaid_applications, :anyone_is_insured, :boolean
    add_column :members, :is_insured, :boolean
    change_column_default :medicaid_applications, :anyone_is_insured, false
    change_column_default :members, :is_insured, false

    safety_assured do
      execute "UPDATE medicaid_applications SET anyone_is_insured=anyone_insured"
      execute "UPDATE members SET is_insured=insured"
      remove_column :medicaid_applications, :anyone_insured
      remove_column :members, :insured
    end
  end
end
