class LivingSituationForm < Step
  def self.application_attributes
    [:living_situation]
  end

  form_attributes(*application_attributes)

  validates :living_situation, inclusion: {
    in: %w(stable_address temporary_address homeless),
    message: "Make sure to answer this question",
  }
end
