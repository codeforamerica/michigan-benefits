require "rails_helper"

RSpec.describe Integrated::PropertyTaxDetailsController do
  it_behaves_like "single expense detail controller", :property_tax, :copays, requesting_food: "yes"
end
