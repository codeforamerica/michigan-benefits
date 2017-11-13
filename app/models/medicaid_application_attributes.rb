class MedicaidApplicationAttributes
  def initialize(medicaid_application:)
    @medicaid_application = medicaid_application
  end

  def to_h
    {
      signature: medicaid_application.signature,
    }.symbolize_keys
  end

  private

  attr_reader :medicaid_application
end
