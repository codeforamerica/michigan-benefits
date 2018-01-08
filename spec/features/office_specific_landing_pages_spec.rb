require "rails_helper"

RSpec.feature "Office-specific landing pages", :js do
  context "applying for FAP" do
    scenario "clio road" do
      visit "/clio"
      proceed_with "Apply for FAP"

      expect(current_path).to eq "/steps/introduce-yourself"
      expect(find("#step_office_location", visible: false).value).to eq("clio")
    end

    scenario "union street" do
      visit "/union"
      proceed_with "Apply for FAP"

      expect(current_path).to eq "/steps/introduce-yourself"
      expect(find("#step_office_location", visible: false).value).to eq("union")
    end

    scenario "regular home page" do
      visit root_path
      within(".slab--hero") { proceed_with "Apply for FAP" }

      expect(current_path).to eq "/steps/introduce-yourself"
      expect(find("#step_office_location", visible: false).value).to eq("")
    end
  end

  xcontext "applying for Medicaid" do
    scenario "clio road" do
      visit "/clio"
      proceed_with "Apply for Medicaid"

      expect(current_path).to eq "/steps/medicaid/welcome"
      expect(find("#step_office_location", visible: false).value).to eq("clio")
    end

    scenario "union street" do
      visit "/union"
      proceed_with "Apply for Medicaid"

      expect(current_path).to eq "/steps/medicaid/welcome"
      expect(find("#step_office_location", visible: false).value).to eq("union")
    end

    scenario "regular home page" do
      visit root_path
      within(".slab--hero") { proceed_with "Apply for Medicaid" }

      expect(current_path).to eq "/steps/medicaid/welcome"
      expect(find("#step_office_location", visible: false).value).to eq("")
    end
  end
end
