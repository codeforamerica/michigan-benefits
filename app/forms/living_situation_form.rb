class LivingSituationForm < Form
  set_attributes_for :application, :living_situation

  validates :living_situation, inclusion: {
    in: %w(stable_address temporary_address homeless),
    message: "Make sure to answer this question",
  }
end
