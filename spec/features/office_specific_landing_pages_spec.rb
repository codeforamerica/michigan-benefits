require "rails_helper"

RSpec.feature "Office-specific landing pages" do
  context "applying for FAP", :single_app_flow do
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

  context "applying for Medicaid", :single_app_flow do
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
    context "when flow is closed" do
      around do |example|
        with_modified_env FLOW_CLOSED_ENABLED: "true" do
          Rails.application.reload_routes!
          example.run
        end
        Rails.application.reload_routes!
      end

      scenario "clio road" do
        visit "/clio"

        expect(page).to have_content("Michigan Benefits is closed")
      end

      scenario "union street" do
        visit "/union"

        expect(page).to have_content("Michigan Benefits is closed")
      end
    end

    context "when flow is open" do
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
end
