require "rails_helper"

RSpec.describe Integrated::OngoingMedicalExpensesDetailsController do
  it_behaves_like "many expenses details controller", :prescriptions, :childcare, requesting_food: "yes"
end
