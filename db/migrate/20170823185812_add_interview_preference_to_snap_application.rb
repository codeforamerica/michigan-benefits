class AddInterviewPreferenceToSnapApplication < ActiveRecord::Migration[5.1]
  def change
    add_column :snap_applications, :interview_preference, :string
  end
end
