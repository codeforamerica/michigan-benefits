require "rails_helper"

RSpec.describe "Pages routing" do
  specify do
    expect(get: "/").to route_to "pages#index"
    expect(get: "/clio").to route_to "pages#clio"
    expect(get: "/union").to route_to "pages#union"
  end
end
