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
        employment.errors.add(:employer_name, "Make sure to enter an employer name.")
      end

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
