class SnapApplication < ApplicationRecord
  CARE_EXPENSES = %w[
    childcare
    disabled_adult_care
  ].freeze

  MEDICAL_EXPENSES = %w[
    health_insurance
    co_pays
    prescriptions
    dental
    in_home_care
    transportation
    hospital_bills
    other
  ].freeze

  COURT_ORDERED_EXPENSES = %w[
    child_support
    alimony
  ].freeze

  validate :care_expenses_values
  validate :medical_expenses_values
  validate :court_ordered_expenses_values

  has_many :addresses, dependent: :destroy
  has_many :driver_applications, dependent: :destroy
  has_many :driver_errors, through: :driver_applications
  has_many :exports, dependent: :destroy
  has_many :members, as: :benefit_application, dependent: :destroy

  scope :signed, -> { where.not(signed_at: nil) }
  scope :unsigned, -> { where(signed_at: nil) }
  scope :untouched_since, ->(threshold) { where("updated_at < ?", threshold) }

  scope :faxed, (lambda do
    where(id: Export.faxed.succeeded.application_ids)
  end)

  scope :unfaxed, (lambda do
    where.not(id: Export.faxed.succeeded.application_ids)
  end)

  scope :emailed_office, (lambda do
    where(id: Export.emailed_office.succeeded.application_ids)
  end)

  scope :emailed_client, (lambda do
    where(id: Export.emailed_client.succeeded.application_ids)
  end)

  scope :unemailed_client, (lambda do
    where.not(id: Export.emailed_client.succeeded.application_ids)
  end)

  def self.step_navigation
    StepNavigation
  end

  def exportable?
    signature.present?
  end

  def drive_status
    if driver_applications.any? && latest_drive_attempt.driver_errors.empty?
      :drive_success
    elsif driver_applications.any? && latest_drive_attempt.driver_errors.any?
      :drive_errors
    else
      :drive_none
    end
  end

  def latest_drive_attempt
    @_latest_drive_attempt ||= driver_applications.
      order("id DESC").
      limit(1).
      first
  end

  def pdf
    @pdf ||= Dhs1171Pdf.new(
      snap_application: self,
    ).completed_file
  end

  def close_pdf
    if @pdf.present? && @pdf.respond_to?(:close)
      @pdf.close
      @pdf.unlink
    end
  end

  def monthly_gross_income
    [
      monthly_additional_income,
      members.map(&:monthly_income),
    ].flatten.compact.reduce(:+)
  end

  def monthly_additional_income
    [
      income_child_support,
      income_other,
      income_pension,
      income_social_security,
      income_ssi_or_disability,
      income_unemployment_insurance,
      income_workers_compensation,
    ].flatten.compact.reduce(:+)
  end

  def mailing_address
    addresses.where(mailing: true).first || NullAddress.new
  end

  def residential_address
    return NullAddress.new if unstable_housing?
    return mailing_address if mailing_address_same_as_residential_address?
    addresses.where.not(mailing: true).first || NullAddress.new
  end

  def zip
    residential_address.zip
  end

  def receiving_office_name
    receiving_office.name
  end

  def receiving_office_email
    receiving_office.email
  end

  def receiving_office
    @receiving_office ||= OfficeRecipient.new(snap_application: self)
  end

  def full_name
    primary_member.full_name
  end

  def birthday
    primary_member.formatted_birthday
  end

  def primary_member
    members.order(:id).first || NullMember.new
  end

  def non_applicant_members
    members - [primary_member]
  end

  def faxed?
    exports.faxed.succeeded.any?
  end

  def faxed_successfully_at
    exports.faxed.succeeded.latest&.completed_at
  end

  def fax_metadata
    [exports.faxed.latest&.status, exports.faxed.latest&.metadata].join(" ")
  end

  def signed?
    signed_at.present?
  end

  def emailed?
    emailed_at.present?
  end

  def emailed_at
    exports.emailed.succeeded.first&.completed_at
  end

  def signed_at_est
    signed_at&.
      in_time_zone("Eastern Time (US & Canada)")&.
      strftime("%m/%d/%Y at %I:%M%p %Z")
  end

  private

  def care_expenses_values
    care_expenses.each do |value|
      if !CARE_EXPENSES.include?(value)
        errors.add(:care_expenses, "'#{value}' is an invalid care expense")
      end
    end
  end

  def medical_expenses_values
    medical_expenses.each do |value|
      if !MEDICAL_EXPENSES.include?(value)
        errors.add(
          :medical_expenses,
          "'#{value}' is an invalid medical expense",
        )
      end
    end
  end

  def court_ordered_expenses_values
    court_ordered_expenses.each do |value|
      if !COURT_ORDERED_EXPENSES.include?(value)
        errors.add(
          :court_ordered_expenses,
          "'#{value}' is an invalid court-ordered expense",
        )
      end
    end
  end
end
