class OfficeRecipient
  def initialize(benefit_application:)
    @benefit_application = benefit_application
  end

  def phone_number
    office["phone_number"]
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
      self.class.find_by(zip: residential_or_mailing_zip)
    end
  end

  def residential_or_mailing_zip
    if benefit_application.respond_to?(:residential_zip)
      benefit_application.residential_zip
    elsif residential_address&.zip
      residential_address.zip
    elsif mailing_address&.zip
      mailing_address.zip
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
    full_configuration[GateKeeper.application_routing_environment]
  end

  def self.full_configuration
    return @full_configuration if @full_configuration.present?
    @full_configuration = YAML.safe_load(configuration_file, [Symbol], [],
                                           true)
    add_names_to_offices(@full_configuration)
    @full_configuration
  end

  def self.add_names_to_offices(configuration)
    configuration.each_key do |stage|
      next unless configuration[stage].key?("offices")
      configuration[stage]["offices"].each_key do |office|
        configuration[stage]["offices"][office]["name"] = office.to_s.titleize
      end
    end
  end

  def self.configuration_file
    File.read(Rails.root.join("config", "offices.yml"))
  end

  private

  attr_reader :benefit_application

  def residential_address
    benefit_application.residential_address
  end

  def mailing_address
    benefit_application.mailing_address
  end

  def office_location
    benefit_application.office_location
  end
end
