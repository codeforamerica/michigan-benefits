require "rails_helper"

RSpec.describe Integrated::TransportationExpensesDetailsController do
  it_behaves_like "single expense detail controller", :transportation, :copays, requesting_food: "yes"
end
