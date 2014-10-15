class CreateAdminRole < ActiveRecord::Migration
  def change
    Role.where(key: Role::ADMIN_ROLE_KEY).first_or_create
  end
end
