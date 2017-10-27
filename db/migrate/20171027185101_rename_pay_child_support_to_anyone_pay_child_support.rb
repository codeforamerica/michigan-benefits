class RenamePayChildSupportToAnyonePayChildSupport < ActiveRecord::Migration[5.1]
  def up
    add_column(:members, :pay_child_support_alimony_arrears, :boolean)
    add_column(
      :medicaid_applications,
      :anyone_pay_child_support_alimony_arrears,
      :boolean,
    )

    safety_assured do
      execute <<~SQL
        UPDATE medicaid_applications
        SET anyone_pay_child_support_alimony_arrears=pay_child_support_alimony_arrears
      SQL

      remove_column(
        :medicaid_applications,
        :pay_child_support_alimony_arrears,
      )
    end
  end

  def down
    add_column(
      :medicaid_applications,
      :pay_child_support_alimony_arrears,
      :boolean,
    )

    safety_assured do
      execute <<~SQL
        UPDATE medicaid_applications
        SET pay_child_support_alimony_arrears=anyone_pay_child_support_alimony_arrears
      SQL

      remove_column(:members, :pay_child_support_alimony_arrears)
      remove_column(
        :medicaid_applications,
        :anyone_pay_child_support_alimony_arrears,
      )
    end
  end
end
