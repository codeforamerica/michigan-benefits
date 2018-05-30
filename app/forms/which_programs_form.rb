class WhichProgramsForm < Form
  set_attributes_for :navigator,
                     :applying_for_food,
                     :applying_for_healthcare

  validate :at_least_one_program_selected

  def at_least_one_program_selected
    return true if applying_for_anything?
    errors.add(:programs, "Make sure to select at least one program")
  end

  private

  def applying_for_anything?
    applying_for_food == "1" || applying_for_healthcare == "1"
  end
end
