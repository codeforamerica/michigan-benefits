class JobDetailsForm < MemberPerPageForm
  set_attributes_for :member,
                     :id, :employments

  set_attributes_for :employment,
                     :employer_name, :hourly_or_salary, :payment_frequency,
                     :pay_quantity_hourly, :pay_quantity_salary, :hours_per_week

  validate :employments_valid

  private

  def employments_valid
    employments.each do |employment|
      employment.errors.clear
      employment.valid?

      if employment.employer_name.blank?
        employment.errors.add(:employer_name, "Make sure to enter an employer name")
      end

      validate_pay_quantity(employment, :hourly)
      validate_pay_quantity(employment, :salary)

      if employment.pay_quantity_salary.present? && employment.pay_quantity_salary !~ Employment::DOLLAR_REGEX
        employment.errors.add(:pay_quantity_salary, "Make sure to enter a dollar amount")
      end

      # TODO: Below validation should be moved to model when we remove old flows.
      # Right now the valid values can differ between SNAP/Medicaid and SNAP + Medicaid,
      # so we keep the validations in the form object.
      unless valid_payment_frequency?(employment)
        employment.errors.add(:payment_frequency, "Make sure to choose a valid frequency")
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

  def validate_pay_quantity(employment, hourly_or_salary)
    field = :"pay_quantity_#{hourly_or_salary}"
    if employment.send(field).present? && employment.send(field) !~ Employment::DOLLAR_REGEX
      employment.errors.add(field, "Make sure to enter a dollar amount")
    end
  end
end
