class CreateCommonApplications < ActiveRecord::Migration[5.1]
  def change
    create_table :common_applications, &:timestamps
  end
end
