require "rails_helper"

RSpec.describe CountyFromZip do
  it "should return the county based on zip code" do
    county = CountyFromZip.new("48480").run
    expect(county).to eq("Genesee")
  end

  it "should return Unknown from non-Michigan zip code" do
    county = CountyFromZip.new("90210").run
    expect(county).to eq("Unknown")
  end
end
