# frozen_string_literal: true

class Fax
  delegate \
    :sfax_api_key,
    :sfax_encryption_key,
    :sfax_init_vector,
    :sfax_username,
    to: :"Rails.application.secrets"

  def self.send_fax(number:, file:, recipient:)
    new(number, file, recipient).send_fax
  end

  def initialize(number, file, recipient)
    @number = number
    @file = file
    @recipient = recipient
  end

  def send_fax
    sfax.send_fax(number, file, recipient)
  end

  private

  attr_reader \
    :file,
    :number,
    :recipient

  def sfax
    SFax::Faxer.new(
      sfax_username,
      sfax_api_key,
      sfax_init_vector,
      sfax_encryption_key,
    )
  end
end
