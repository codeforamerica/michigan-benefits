require "rails_helper"

RSpec.describe Integrated::AlimonyDetailsController do
  it_behaves_like "single expense detail controller", :alimony, :copays, requesting_food: "yes"
end
