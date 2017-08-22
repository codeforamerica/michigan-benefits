class PrivacyPinPage
  def fill_in_required_fields
    choose(
      "This is a private computer. Example: Personal computer at your home.",
    )
  end

  def submit
    click_on "Next"
  end
end
