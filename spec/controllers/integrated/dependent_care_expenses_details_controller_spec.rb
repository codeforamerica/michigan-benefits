require "rails_helper"

RSpec.describe Integrated::DependentCareExpensesDetailsController do
  it_behaves_like "expense detail controller", :disability_care, :childcare
end
