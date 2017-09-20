require "rails_helper"

RSpec.feature "Admins can view members" do
  before do
    page.driver.browser.current_session.basic_authorize("admin", "password")
  end

  scenario "Members is linked from the navigation" do
    visit admin_root_path

    within ".navigation" do
      expect(page).to have_link("Members")
    end
  end

  scenario "Members are listed" do
    john = create(:member, first_name: "john", last_name: "doe")
    joe  = create(:member, first_name: "joe", last_name: "schmoe")

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
