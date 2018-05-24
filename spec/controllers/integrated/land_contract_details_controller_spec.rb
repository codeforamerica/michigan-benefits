require "rails_helper"

RSpec.describe Integrated::LandContractDetailsController do
  it_behaves_like "single expense detail controller", :land_contract, :copays
end
