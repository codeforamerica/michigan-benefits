class AddMoneyInAccountsToNavigator < ActiveRecord::Migration[5.1]
  def change
    add_column :application_navigators, :money_in_accounts, :boolean
    change_column_default :application_navigators, :money_in_accounts, from: nil, to: false
  end
end
