require "rails_helper"

RSpec.describe Integrated::DependentCareExpensesDetailsController do
  it_behaves_like "single expense detail controller", :disability_care, :childcare, requesting_food: "yes"
end
