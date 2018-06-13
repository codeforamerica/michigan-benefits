require "rails_helper"

RSpec.feature "Office-specific landing pages" do
  context "applying for FAP" do
    scenario "clio road" do
      visit "/clio"
      click_on "Apply for FAP"

      expect(current_path).to eq "/steps/introduce-yourself"
      expect(find("#step_office_page", visible: false).value).to eq("clio")
    end

    scenario "union street" do
      visit "/union"
      click_on "Apply for FAP"

      expect(current_path).to eq "/steps/introduce-yourself"
      expect(find("#step_office_page", visible: false).value).to eq("union")
    end

    scenario "regular home page" do
      visit root_path
      within(".slab--hero") { click_on "Apply for FAP" }

      expect(current_path).to eq "/steps/introduce-yourself"
      expect(find("#step_office_page", visible: false).value).to be_nil
    end
  end

  context "applying for Medicaid" do
    scenario "clio road" do
      visit "/clio"
      click_on "Apply for Medicaid"

      expect(current_path).to eq "/steps/medicaid/welcome"
      expect(find("#step_office_page", visible: false).value).to eq("clio")
    end

    scenario "union street" do
      visit "/union"
      click_on "Apply for Medicaid"

      expect(current_path).to eq "/steps/medicaid/welcome"
      expect(find("#step_office_page", visible: false).value).to eq("union")
    end

    scenario "regular home page" do
      visit root_path
      within(".slab--hero") { click_on "Apply for Medicaid" }

      expect(current_path).to eq "/steps/medicaid/welcome"
      expect(find("#step_office_page", visible: false).value).to be_nil
    end
  end

  context "applying via integrated application" do
    before do
      ENV["INTEGRATED_APPLICATION_ENABLED"] = "true"
    end

    after do
      ENV["INTEGRATED_APPLICATION_ENABLED"] = "false"
    end

    scenario "clio road" do
      visit "/clio"
      click_on "Start your application"

      expect(current_path).to eq(section_path(FormNavigation.first))
      expect(find("#form_office_page", visible: false).value).to eq("clio")
    end

    scenario "union street" do
      visit "/union"
      click_on "Start your application"

      expect(current_path).to eq(section_path(FormNavigation.first))
      expect(find("#form_office_page", visible: false).value).to eq("union")
    end

    scenario "regular home page" do
      visit root_path
      click_on "Start your application"

      expect(current_path).to eq(section_path(FormNavigation.first))
      expect(find("#form_office_page", visible: false).value).to be_nil
    end
  end
end
