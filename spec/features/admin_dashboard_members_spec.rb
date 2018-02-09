require "rails_helper"

RSpec.feature "Admins can view members" do
  before do
    user = create(:admin_user)
    login_as(user)
  end

  scenario "Members is linked from the navigation" do
    visit admin_root_path

    within ".navigation" do
      expect(page).to have_link("Members")
    end
  end

  scenario "searching isn't broken", javascript: true do
    visit admin_members_path(search: "adsf")

    expect(page).to have_content("Members")
  end

  scenario "Members are listed" do
    benefit_application = build(:medicaid_application)
    john = create(
      :member,
      first_name: "john",
      last_name: "doe",
      benefit_application: benefit_application,
    )
    joe = create(
      :member,
      first_name: "joe",
      last_name: "schmoe",
      benefit_application: benefit_application,
    )

    visit admin_members_path

    within "[data-url='#{admin_member_path(john)}']" do
      expect(page).to have_content "john"
      expect(page).to have_content "doe"
    end

    within "[data-url='#{admin_member_path(joe)}']" do
      expect(page).to have_content "joe"
      expect(page).to have_content "schmoe"
    end
  end
end
