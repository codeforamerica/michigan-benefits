require "rails_helper"

RSpec.describe Integrated::HomeownersInsuranceDetailsController do
  it_behaves_like "single expense detail controller", :homeowners_insurance, :copays, requesting_food: "yes"
end
