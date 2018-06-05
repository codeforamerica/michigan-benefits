require "rails_helper"

RSpec.describe Integrated::MortgageDetailsController do
  it_behaves_like "single expense detail controller", :mortgage, :copays, requesting_food: "yes"
end
