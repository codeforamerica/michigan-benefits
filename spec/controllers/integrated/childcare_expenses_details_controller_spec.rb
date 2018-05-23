require "rails_helper"

RSpec.describe Integrated::ChildcareExpensesDetailsController do
  it_behaves_like "expense detail controller", :childcare, :disability_care
end
