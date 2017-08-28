class FaxRecipient
  attr_accessor :residential_address

  def initialize(residential_address:)
    @residential_address = residential_address
  end

  def number
    self.class.find_by(zip: residential_address.zip)["fax_number"]
  end

  def name
    ENV.fetch("FAX_RECIPIENT", "Michigan Bridges")
  end

  def self.find_by(zip:)
    covered_zip_codes.detect do |(name, zip_codes)|
      return offices[name] if zip_codes.include?(zip)
    end
    offices[configuration["fallback_office"].to_s]
  end

  def self.covered_zip_codes
    configuration["covered_zip_codes"]
  end

  def self.offices
    configuration["offices"]
  end

  def self.configuration
    full_configuration[release_stage]
  end

  def self.full_configuration
    @full_configuration ||= YAML.safe_load(configuration_file, [Symbol], [],
                                           true)
  end

  def self.configuration_file
    File.read(Rails.root.join("config", "offices.yml"))
  end

  def self.release_stage
    ENV.fetch("APP_RELEASE_STAGE", "development")
  end
end
