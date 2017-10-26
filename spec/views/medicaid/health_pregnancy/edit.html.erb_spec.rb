require "rails_helper"

describe "medicaid/health_pregnancy/edit.html.erb" do
  before do
    controller.singleton_class.class_eval do
      def current_path
        "/steps/medicaid/health-pregnancy"
      end

      helper_method :current_path
    end
  end

  context "2 members - primary member is male" do
    it "asks if the only *other* female is pregnant" do
      app = create(:medicaid_application, anyone_new_mom: true)
      create(:member, :male, first_name: "Joel", benefit_application: app)
      create(:member, :female, first_name: "Sara", benefit_application: app)
      pregnancy_step = Medicaid::HealthPregnancy.new(
        anyone_new_mom: true,
        members: app.members,
      )

      assign(:step, pregnancy_step)

      render

      expect(rendered).to include("Has Sara been pregnant recently?")
    end
  end

  context "2 members - primary member is female" do
    it "asks if *YOU*, the primary member, has been pregnant" do
      app = create(:medicaid_application, anyone_new_mom: true)
      create(:member, :female, first_name: "Sara", benefit_application: app)
      create(:member, :male, first_name: "Joel", benefit_application: app)
      pregnancy_step = Medicaid::HealthPregnancy.new(
        anyone_new_mom: true,
        members: app.members,
      )

      assign(:step, pregnancy_step)

      render

      expect(rendered).to include("Have you been pregnant recently?")
    end
  end

  context "2 members - both are female" do
    it "asks if anyone has been pregnant recently" do
      app = create(:medicaid_application, anyone_new_mom: true)
      create(:member, :female, first_name: "Sara", benefit_application: app)
      create(:member, :female, first_name: "Jessie", benefit_application: app)
      pregnancy_step = Medicaid::HealthPregnancy.new(
        anyone_new_mom: true,
        members: app.members,
      )

      assign(:step, pregnancy_step)

      render

      expect(rendered).to include("Has anyone been pregnant recently?")
    end
  end
end
