require "rails_helper"

RSpec.describe CountyFinder do
  it "should find the county based on street and city" do
    expect(Geocoder).to receive(:search).with(
      "2405 West Vernor Highway Detroit MI 48216",
      countrycode: "us",
    ).and_return([double("result", county: "Wayne County")])

    expect(CountyFinder.new(
      street_address: "2405 West Vernor Highway",
      city: "Detroit",
      state: "MI",
      zip: "48216",
    ).run).to eq "Wayne County"
  end

  it "should return nil if no results can be found" do
    expect(Geocoder).to receive(:search).with(
      "2405 West Vernor Highway Detroit MI 48216",
      countrycode: "us",
    ).and_return([])

    expect(CountyFinder.new(
      street_address: "2405 West Vernor Highway",
      city: "Detroit",
      state: "MI",
      zip: "48216",
    ).run).to eq nil
  end
end
