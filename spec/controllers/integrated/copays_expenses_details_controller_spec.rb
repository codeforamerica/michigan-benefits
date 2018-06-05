require "rails_helper"

RSpec.describe Integrated::CopaysExpensesDetailsController do
  it_behaves_like "single expense detail controller", :copays, :health_insurance, requesting_food: "yes"
end
