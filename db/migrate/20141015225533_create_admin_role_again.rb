class CreateAdminRoleAgain < ActiveRecord::Migration
  def change
    Role.where(key: Role::ADMIN_ROLE_KEY).first_or_create!(name: "Admin")
  end
end
