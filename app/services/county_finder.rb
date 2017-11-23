class CountyFinder
  def initialize(address)
    @address = address
  end

  def run

    full_address = [
      @address.street_address,
      @address.city,
      @address.state,
      @address.zip,
    ].join(" ")
    results = Geocoder.search(full_address, countrycode: "us")

    results.first&.county
  end
end
