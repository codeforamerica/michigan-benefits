class WhichProgramsForm < Form
  set_attributes_for :navigator,
                     :applying_for_food,
                     :applying_for_healthcare

  set_attributes_for :application, :office_page

  validate :at_least_one_program_selected

  validates(
    :office_page,
    allow_blank: true,
    inclusion: {
      in: %w(clio union)
    },
  )

  def at_least_one_program_selected
    return true if applying_for_anything?
    errors.add(:programs, "Make sure to select at least one program")
  end

  private

  def applying_for_anything?
    applying_for_food == "1" || applying_for_healthcare == "1"
  end
end
