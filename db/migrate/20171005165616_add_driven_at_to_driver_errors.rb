class AddDrivenAtToDriverErrors < ActiveRecord::Migration[5.1]
  def up
    add_column :driver_applications, :driven_at, :datetime
    add_column :driver_errors, :driven_at, :datetime

    execute <<~SQL
      UPDATE driver_applications SET driven_at=now();
      UPDATE driver_errors SET driven_at=now();
    SQL

    change_column_null :driver_applications, :driven_at, false
    change_column_null :driver_errors, :driven_at, false
  end

  def down
    remove_column :driver_applications, :driven_at
    remove_column :driver_errors, :driven_at
  end
end
