require "rails_helper"

RSpec.describe Integrated::TransportationExpensesDetailsController do
  it_behaves_like "expense detail controller", :transportation, :copays
end
