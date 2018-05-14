class JobDetailsForm < Form
  set_member_attributes(:id, :employments)

  set_employment_attributes(
    :employer_name,
    :hourly_or_salary,
    :payment_frequency,
    :pay_quantity_hourly,
    :pay_quantity_salary,
    :hours_per_week,
  )

  validate :employments_valid
  validate :current_member_id_valid

  def valid_members=(members)
    @valid_members = members
  end

  def current_member_id_valid
    return true if @valid_members.map { |m| m.id.to_s }.include?(id)
    errors.add(:id, "Can't update that household member.")
    false
  end

  private

  def employments_valid
    employments.each do |employment|
      employment.errors.clear
      employment.valid?

      # TODO: Below validation should be moved to model when we remove old flows.
      # Right now the valid values can differ between SNAP/Medicaid and SNAP + Medicaid,
      # so we keep the validations in the form object.
      unless valid_payment_frequency?(employment)
        employment.errors.add(:payment_frequency, "Make sure to choose a valid frequency.")
      end
    end

    return true if employments.map(&:errors).all?(&:blank?)
    errors.add(:employments)
    false
  end

  def valid_payment_frequency?(employment)
    return true unless employment.payment_frequency.present?
    Employment::PAYCHECK_INTERVALS.keys.map(&:to_s).include?(employment.payment_frequency)
  end
end
