class CountyFromZip
  def initialize(zip)
    @zip = zip
  end

  def run
    lookup = YAML.load_file(Rails.root.join("config", "zips.yml"))
    lookup[@zip] || "Unknown"
  end
end
