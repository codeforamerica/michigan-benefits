require "rails_helper"

RSpec.describe Integrated::RentDetailsController do
  it_behaves_like "single expense detail controller", :rent, :copays, requesting_food: "yes"
end
