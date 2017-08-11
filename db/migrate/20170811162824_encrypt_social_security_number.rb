class EncryptSocialSecurityNumber < ActiveRecord::Migration[5.1]
  def change
    add_column :members, :encrypted_ssn, :string
    add_column :members, :encrypted_ssn_iv, :string
    remove_column :members, :social_security_number, :string
  end
end
