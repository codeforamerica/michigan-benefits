class CountyFinder
  def initialize(street_address:, city:, zip:, state:)
    @street_address = street_address
    @city = city
    @state = state
    @zip = zip
  end

  def run
    full_address = [
      @street_address,
      @city,
      @state,
      @zip,
    ].compact.join(" ")
    results = Geocoder.search(full_address, countrycode: "us")

    results.first&.county
  end
end
