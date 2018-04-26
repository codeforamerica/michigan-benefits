class AddApplicationMemberToEmployments < ActiveRecord::Migration[5.1]
  def up
    change_column_null :employments, :member_id, true

    add_column :employments, :application_member_id, :bigint
    add_column :employments, :application_member_type, :string

    commit_db_transaction

    add_index :employments, :application_member_id, algorithm: :concurrently
  end

  def down
    change_column_null :employments, :member_id, false

    remove_column :employments, :application_member_id, :bigint
    remove_column :employments, :application_member_type, :string
  end
end
