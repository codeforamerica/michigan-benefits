# frozen_string_literal: true

class AddHouseholdIntroductionData < ActiveRecord::Migration[5.0]
  def change
    add_column :apps, :birthday, :date
    add_column :apps, :sex, :string
    add_column :apps, :marital_status, :string
    add_column :apps, :household_size, :integer
  end
end
