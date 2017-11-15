class AddClaimedAsDependentToMember < ActiveRecord::Migration[5.1]
  def change
    add_column :members, :claimed_as_dependent, :boolean
  end
end
