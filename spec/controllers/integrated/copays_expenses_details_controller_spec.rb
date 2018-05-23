require "rails_helper"

RSpec.describe Integrated::CopaysExpensesDetailsController do
  it_behaves_like "expense detail controller", :copays, :health_insurance
end
