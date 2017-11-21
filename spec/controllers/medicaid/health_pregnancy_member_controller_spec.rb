require "rails_helper"

RSpec.describe Medicaid::HealthPregnancyMemberController, type: :controller do
  describe "#next_path" do
    it "is the  path" do
      expect(subject.next_path).to eq(
        "/steps/medicaid/health-flint-water-crisis",
      )
    end
  end

  it_should_behave_like "Medicaid multi-member controller", :anyone_new_mom

  describe "#edit" do
    context "only one female and answered that someone was pregnant" do
      it "redirects to the next page" do
        medicaid_application = create(
          :medicaid_application,
          anyone_new_mom: true,
        )
        create(
          :member,
          sex: "female",
          benefit_application: medicaid_application,
        )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to redirect_to(subject.next_path)
      end
    end

    context "there are no female members" do
      it "redirects to the next page" do
        medicaid_application = create(:medicaid_application)
        create(
          :member,
          sex: "male",
          benefit_application: medicaid_application,
        )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to redirect_to(subject.next_path)
      end
    end

    context "members include females" do
      it "renders :edit" do
        medicaid_application = create(
          :medicaid_application,
          anyone_new_mom: true,
          members: build_list(:member, 2, sex: "female"),
        )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to render_template(:edit)
      end
    end
  end
end
