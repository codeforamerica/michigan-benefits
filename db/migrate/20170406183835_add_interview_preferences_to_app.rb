class AddInterviewPreferencesToApp < ActiveRecord::Migration[5.0]
  def change
    add_column :apps, :preference_for_interview, :string
  end
end
