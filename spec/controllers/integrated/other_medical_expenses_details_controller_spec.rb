require "rails_helper"

RSpec.describe Integrated::OtherMedicalExpensesDetailsController do
  it_behaves_like "single expense detail controller", :other_medical, :copays
end
