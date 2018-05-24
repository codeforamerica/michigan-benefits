require "rails_helper"

RSpec.describe Integrated::ChildSupportDetailsController do
  it_behaves_like "single expense detail controller", :child_support, :copays
end
