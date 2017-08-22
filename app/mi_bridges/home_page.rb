class HomePage
  def visit
    visit "https://www.mibridges.michigan.gov/access/"
  end

  def submit
    click_on "Create An Account"
  end
end
