class FaxRecipient
  def initialize(snap_application:)
    @snap_application = snap_application
  end

  def number
    if office_location.present?
      self.class.offices[office_location]["fax_number"]
    else
      self.class.find_by(zip: residential_address.zip)["fax_number"]
    end
  end

  def name
    office["name"].to_s.titleize
  end

  def office
    if office_location.present?
      office = self.class.offices[office_location]
      office["name"] = office_location
      office
    else
      self.class.find_by(zip: residential_address.zip)
    end
  end

  def self.find_by(zip:)
    name = covered_zip_codes[zip] || configuration["fallback_office"]
    Rails.logger.debug("Mapped zip #{zip} to office #{name}")
    offices[name]["name"] = name
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

  attr_reader :snap_application

  def residential_address
    snap_application.residential_address
  end

  def office_location
    snap_application.office_location
  end
end
