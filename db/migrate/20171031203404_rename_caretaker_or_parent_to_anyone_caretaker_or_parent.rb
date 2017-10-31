class RenameCaretakerOrParentToAnyoneCaretakerOrParent < ActiveRecord::Migration[5.1]
  def up
    add_column(
      :medicaid_applications,
        :anyone_caretaker_or_parent,
        :boolean,
    )

    safety_assured do
      execute <<~SQL
        UPDATE medicaid_applications
        SET anyone_caretaker_or_parent=caretaker_or_parent
      SQL

      remove_column(
        :medicaid_applications,
          :caretaker_or_parent,
      )
    end
  end

  def down
    add_column(
      :medicaid_applications,
        :caretaker_or_parent,
        :boolean,
    )

    safety_assured do
      execute <<~SQL
        UPDATE medicaid_applications
        SET caretaker_or_parent=anyone_caretaker_or_parent
      SQL

      remove_column(
        :medicaid_applications,
          :anyone_caretaker_or_parent,
      )
    end
  end
end
