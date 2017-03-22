class AddMailingFieldsToApp < ActiveRecord::Migration[5.0]
  def change
    add_column :apps, :mailing_street, :string
    add_column :apps, :mailing_city, :string
    add_column :apps, :mailing_zip, :string
  end
end
