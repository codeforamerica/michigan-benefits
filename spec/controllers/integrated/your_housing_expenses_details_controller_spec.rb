require "rails_helper"

RSpec.describe Integrated::YourHousingExpensesDetailsController do
  it_behaves_like "many expenses details controller", :rent, :childcare, requesting_food: "yes"
end
