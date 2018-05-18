require "rails_helper"

RSpec.describe Integrated::HospitalBillsExpensesDetailsController do
  it_behaves_like "expense detail controller", :hospital_bills, :copays
end
