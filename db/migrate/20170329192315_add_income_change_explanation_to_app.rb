# frozen_string_literal: true

class AddIncomeChangeExplanationToApp < ActiveRecord::Migration[5.0]
  def change
    add_column :apps, :income_change_explanation, :text
  end
end
