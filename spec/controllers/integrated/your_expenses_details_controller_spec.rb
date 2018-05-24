require "rails_helper"

RSpec.describe Integrated::YourExpensesDetailsController do
  it_behaves_like "many expenses details controller", :alimony, :childcare
end
