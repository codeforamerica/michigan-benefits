class RenameUnstableHousingToStableHousing < ActiveRecord::Migration[5.1]
  def up
    add_column :snap_applications, :stable_housing, :boolean
    change_column_default :snap_applications, :stable_housing, from: nil, to: true

    safety_assured do
      execute <<~SQL
        UPDATE snap_applications
        SET stable_housing = not unstable_housing
      SQL

      remove_column :snap_applications, :unstable_housing
    end
  end

  def down
    add_column :snap_applications, :unstable_housing, :boolean
    change_column_default :snap_applications, :unstable_housing, from: nil, to: false

    safety_assured do
      execute <<~SQL
         UPDATE snap_applications
        SET unstable_housing = not stable_housing
      SQL

      remove_column :snap_applications, :stable_housing
    end
  end
end
