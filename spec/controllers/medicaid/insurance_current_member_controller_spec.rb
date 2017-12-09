require "rails_helper"

RSpec.describe Medicaid::InsuranceCurrentMemberController, type: :controller do
  describe "#next_path" do
    it "is the  path" do
      expect(subject.next_path).to eq(
        "/steps/medicaid/insurance-current-type",
      )
    end
  end

  it_should_behave_like "Medicaid multi-member controller", :anyone_insured

  describe "#edit" do
    context "multi member household with one member requesting insurance" do
      it "renders with correct members" do
        member_requesting_insurance = build(
          :member,
          requesting_health_insurance: true,
        )
        member_not_requesting_insurance = build(
          :member,
          requesting_health_insurance: false,
        )
        medicaid_application = create(
          :medicaid_application,
          anyone_insured: true,
          members: [
            member_requesting_insurance,
            member_not_requesting_insurance,
          ],
        )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to render_template(:edit)
        expect(assigns[:step].members).to eq [member_requesting_insurance]
      end
    end
  end

  describe "#members_not_needing_insurance" do
    context "multi member household with one member requesting insurance" do
      it "returns members not requesting insurance" do
        member_requesting_insurance = build(
          :member,
          requesting_health_insurance: true,
        )
        member_not_requesting_insurance = build(
          :member,
          requesting_health_insurance: false,
        )
        medicaid_application = create(
          :medicaid_application,
          anyone_insured: true,
          members: [
            member_requesting_insurance,
            member_not_requesting_insurance,
          ],
        )

        session[:medicaid_application_id] = medicaid_application.id

        expect(subject.members_not_needing_insurance).to eq(
          [member_not_requesting_insurance],
        )
      end
    end
  end

  describe "#update" do
    context "multi member household with one member requesting insurance" do
      it "with correct members" do
        member = build(
          :member,
          requesting_health_insurance: true,
        )
        medicaid_application = create(
          :medicaid_application,
          anyone_insured: true,
          members: [member],
        )
        session[:medicaid_application_id] = medicaid_application.id

        put :update, params: {
          step: {
            members: {
              member.id => { insured: 1 },
            },
          },
        }

        member.reload
        expect(member.insured).to eq(true)
      end
    end
  end
end
