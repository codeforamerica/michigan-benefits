require "rails_helper"

RSpec.describe "Pages routing" do
  specify do
    expect(get: "/").to route_to "static_pages#index"
    expect(get: "/clio").to route_to "static_pages#clio"
    expect(get: "/union").to route_to "static_pages#union"
  end
end
