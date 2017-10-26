class RenameDisabledToAnyoneDisabled < ActiveRecord::Migration[5.1]
  def up
    add_column :medicaid_applications, :anyone_disabled, :boolean

    safety_assured do
      execute "UPDATE medicaid_applications SET anyone_disabled=disabled"
      remove_column :medicaid_applications, :disabled
    end
  end

  def down
    add_column :medicaid_applications, :disabled, :boolean

    safety_assured do
      execute "UPDATE medicaid_applications SET disabled=anyone_disabled"
      remove_column :medicaid_applications, :anyone_disabled
    end
  end
end
