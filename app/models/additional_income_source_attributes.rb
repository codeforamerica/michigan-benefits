class AdditionalIncomeSourceAttributes
  def initialize(source:, position:, snap_application:)
    @source = source
    @position = position
    @snap_application = snap_application
  end

  def to_h
    {
      "#{position}_additional_income_type" => source.titleize,
      "#{position}_additional_income_amount" => find_amount,
    }.symbolize_keys
  end

  private

  attr_reader :source, :position, :snap_application

  def find_amount
    snap_application.send("income_#{source}".to_sym)
  end
end
