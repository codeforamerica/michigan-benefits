require "rails_helper"

RSpec.describe Integrated::ChildcareExpensesDetailsController do
  it_behaves_like "single expense detail controller", :childcare, :disability_care, requesting_food: "yes"
end
