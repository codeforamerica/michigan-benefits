class IncomeAdditional < Step
  self.title = "Money & Income"
  self.subhead = "Tell us more about your additional income."

  ATTRS = [
    :income_child_support,
    :income_unemployment,
    :income_ssi,
    :income_workers_comp,
    :income_pension,
    :income_social_security,
    :income_foster_care,
    :income_other
  ]

  attr_accessor *ATTRS

  def skip?
    ATTRS.none? { |attr| @app.additional_income.include?(attr.to_s.remove("income_")) }
  end

  def allowed_params
    ATTRS.map(&:to_s)
  end

  def assign_from_app
    assign_attributes @app.attributes.slice(*ATTRS.map(&:to_s))
  end

  def update_app!
    @app.update!(
      ATTRS.each_with_object({}) { |attr, hash| hash[attr] = self.send(attr) }
    )
  end
end
