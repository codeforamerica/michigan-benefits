# frozen_string_literal: true

class AddFinancialAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :apps, :financial_accounts, :text, array: true, default: []
  end
end
