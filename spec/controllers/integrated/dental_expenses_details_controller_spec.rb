require "rails_helper"

RSpec.describe Integrated::DentalExpensesDetailsController do
  it_behaves_like "expense detail controller", :dental, :copays
end
