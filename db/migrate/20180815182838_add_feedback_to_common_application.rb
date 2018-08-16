class AddFeedbackToCommonApplication < ActiveRecord::Migration[5.2]
  def change
    add_column :common_applications, :feedback_rating, :integer
    change_column_default :common_applications, :feedback_rating, from: nil, to: 0

    add_column :common_applications, :feedback_comments, :text
  end
end
