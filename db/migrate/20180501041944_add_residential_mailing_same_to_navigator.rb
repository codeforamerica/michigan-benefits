class AddResidentialMailingSameToNavigator < ActiveRecord::Migration[5.1]
  def change
    add_column :application_navigators, :residential_mailing_same, :boolean
    change_column_default :application_navigators, :residential_mailing_same, from: nil, to: true
  end
end
