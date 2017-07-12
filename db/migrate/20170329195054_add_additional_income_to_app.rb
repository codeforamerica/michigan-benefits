# frozen_string_literal: true

class AddAdditionalIncomeToApp < ActiveRecord::Migration[5.0]
  def change
    add_column :apps, :additional_income, :text, array: true, default: []
  end
end
