require "rails_helper"

RSpec.describe Integrated::InHomeCareExpensesDetailsController do
  it_behaves_like "single expense detail controller", :in_home_care, :copays
end
