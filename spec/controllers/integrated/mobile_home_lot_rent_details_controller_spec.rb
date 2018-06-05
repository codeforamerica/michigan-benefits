require "rails_helper"

RSpec.describe Integrated::MobileHomeLotRentDetailsController do
  it_behaves_like "single expense detail controller", :mobile_home_lot_rent, :copays, requesting_food: "yes"
end
