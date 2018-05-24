require "rails_helper"

RSpec.describe Integrated::StudentLoanInterestDetailsController do
  it_behaves_like "single expense detail controller", :student_loan_interest, :copays
end
