class ChangeAuthorizedRep < ActiveRecord::Migration[5.1]
  def change
    safety_assured do
      change_column_default :common_applications, :authorized_representative, from: false, to: nil
      change_column :common_applications, :authorized_representative, :integer,
                    using: "CASE WHEN \"authorized_representative\" THEN 1 ELSE 0 END"
      change_column_default :common_applications, :authorized_representative, from: nil, to: 0
    end
  end
end
