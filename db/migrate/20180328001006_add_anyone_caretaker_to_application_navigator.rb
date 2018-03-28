class AddAnyoneCaretakerToApplicationNavigator < ActiveRecord::Migration[5.1]
  def change
    add_column :application_navigators, :anyone_caretaker, :boolean
    change_column_default :application_navigators, :anyone_caretaker, from: nil, to: true
  end
end
