class OfficeRecipient
  def initialize(snap_application:)
    @snap_application = snap_application
  end

  def number
    office["fax_number"]
  end

  def name
    office["name"]
  end

  def email
    office["email"]
  end

  def office
    if office_location.present?
      self.class.offices[office_location]
    else
      self.class.find_by(zip: residential_address.zip)
    end
  end

  def self.find_by(zip:)
    name = covered_zip_codes[zip.to_s] || configuration["fallback_office"]
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
    return @full_configuration if @full_configuration.present?
    @full_configuration = YAML.safe_load(configuration_file, [Symbol], [],
                                           true)
    add_names_to_offices(@full_configuration)
    @full_configuration
  end

  def self.add_names_to_offices(configuration)
    configuration.keys.each do |stage|
      next unless configuration[stage].key?("offices")
      configuration[stage]["offices"].keys.each do |office|
        configuration[stage]["offices"][office]["name"] = office.to_s.titleize
      end
    end
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
