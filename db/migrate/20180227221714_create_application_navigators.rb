class CreateApplicationNavigators < ActiveRecord::Migration[5.1]
  def change
    create_table :application_navigators do |t|
      t.references :common_application, index: true
      t.boolean :resides_in_state, default: true
      t.timestamps
    end
  end
end
