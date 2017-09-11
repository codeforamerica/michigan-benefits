class CreateExports < ActiveRecord::Migration[5.1]
  def change
    create_table :exports do |t|
      t.references :snap_application
      t.string :destination
      t.string :metadata
      t.boolean :force, default: false
      t.string :status, default: "new"
      t.datetime :completed_at
      t.timestamps
    end
  end
end
