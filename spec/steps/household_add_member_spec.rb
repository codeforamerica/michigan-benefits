require "rails_helper"

RSpec.describe HouseholdAddMember do
  let(:subject) do
    HouseholdAddMember.new(
      first_name: "Light",
      last_name: "Bulb",
      requesting_food_assistance: "true",
    )
  end

  include_examples "social security number"
end
