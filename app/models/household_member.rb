class HouseholdMember < ApplicationRecord
  belongs_to :app

  def full_name
    [first_name, last_name].join(" ")
  end
end
