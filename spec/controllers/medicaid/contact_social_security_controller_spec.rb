require "rails_helper"

RSpec.describe Medicaid::ContactSocialSecurityController do
  describe "#next_path" do
    it "is the paperwork guide page" do
      expect(subject.next_path).to eq(
        "/steps/medicaid/paperwork-and-legal-introduction",
      )
    end
  end

  describe "#edit" do
    context "client will not submit ssn" do
      it "redirects to next step" do
        medicaid_application = create(:medicaid_application, submit_ssn: false)
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to redirect_to(subject.next_path)
      end
    end

    context "client will submit ssn" do
      it "renders edit" do
        medicaid_application = create(:medicaid_application, submit_ssn: true)
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to render_template(:edit)
      end

      it "assigns members requesting health insurance to step" do
        member_one = build(:member, requesting_health_insurance: true)
        member_two = build(:member, requesting_health_insurance: true)
        member_three = build(:member, requesting_health_insurance: false)

        medicaid_application = create(
          :medicaid_application,
          submit_ssn: true,
          members: [member_one, member_two, member_three],
        )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(assigns[:step].members).to eq [member_one, member_two]
      end
    end
  end

  describe "#update" do
    it "updates each member's SSN" do
      member_one = build(:member, requesting_health_insurance: true)
      member_two = build(:member, requesting_health_insurance: true)
      medicaid_application = create(
        :medicaid_application,
        members: [
          member_one,
          member_two,
        ],
      )
      session[:medicaid_application_id] = medicaid_application.id

      put(
        :update,
        params: {
          step: {
            members: {
              member_one.id => {
                ssn: "123456789",
              },
              member_two.id => {
                ssn: "111222333",
              },
            },
          },
        },
      )
      member_one.reload
      member_two.reload

      expect(member_one.ssn).to eq("123456789")
      expect(member_two.ssn).to eq("111222333")
    end
  end
end
