class AddAdditionalInformationToCommonApplication < ActiveRecord::Migration[5.1]
  def change
    add_column :common_applications, :additional_information, :string
  end
end
