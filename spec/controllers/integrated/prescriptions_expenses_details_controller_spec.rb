require "rails_helper"

RSpec.describe Integrated::PrescriptionsExpensesDetailsController do
  it_behaves_like "single expense detail controller", :prescriptions, :health_insurance
end
