require "rails_helper"

RSpec.describe Integrated::HealthInsuranceExpensesDetailsController do
  it_behaves_like "single expense detail controller", :health_insurance, :copays
end
