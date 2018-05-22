require "rails_helper"

RSpec.describe Integrated::AlimonyDetailsController do
  it_behaves_like "expense detail controller", :alimony, :copays
end
