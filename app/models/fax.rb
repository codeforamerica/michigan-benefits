# frozen_string_literal: true

class Fax
  delegate \
    :sfax_api_key,
    :sfax_encryption_key,
    :sfax_init_vector,
    :sfax_username,
    to: :"Rails.application.secrets"

  def self.send_fax(number:, file:)
    new(number, file).send_fax
  end

  def initialize(number, file)
    @number = number
    @file = file
  end

  def send_fax
    sfax.send_fax(number, file)
  end

  protected

  attr_reader :file, :number

  private

  def sfax
    SFax::Faxer.new(
      sfax_username,
      sfax_api_key,
      sfax_init_vector,
      sfax_encryption_key,
    )
  end
end
