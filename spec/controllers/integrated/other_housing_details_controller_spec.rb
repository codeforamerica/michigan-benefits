require "rails_helper"

RSpec.describe Integrated::OtherHousingDetailsController do
  it_behaves_like "single expense detail controller", :other_housing, :copays, requesting_food: "yes"
end
