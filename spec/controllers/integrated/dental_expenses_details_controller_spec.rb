require "rails_helper"

RSpec.describe Integrated::DentalExpensesDetailsController do
  it_behaves_like "single expense detail controller", :dental, :copays, requesting_food: "yes"
end
