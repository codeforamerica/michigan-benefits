class FaxRecipient
  attr_accessor :residential_address

  def initialize(residential_address:, office_location: "")
    @residential_address = residential_address
    @office_location = office_location
  end

  def number
    if office_location.present?
      self.class.offices[office_location]["fax_number"]
    else
      self.class.find_by(zip: residential_address.zip)["fax_number"]
    end
  end

  def name
    ENV.fetch("FAX_RECIPIENT", "Michigan Bridges")
  end

  def self.find_by(zip:)
    name = covered_zip_codes[zip] || configuration["fallback_office"]
    Rails.logger.debug("Mapped zip #{zip} to office #{name}")
    offices[name]
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

  private

  attr_reader :office_location
end
