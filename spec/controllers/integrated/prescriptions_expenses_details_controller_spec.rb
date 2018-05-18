require "rails_helper"

RSpec.describe Integrated::PrescriptionsExpensesDetailsController do
  it_behaves_like "expense detail controller", :prescriptions, :health_insurance
end
