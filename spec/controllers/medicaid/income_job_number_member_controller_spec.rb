require "rails_helper"

RSpec.describe Medicaid::IncomeJobNumberMemberController do
  describe "#next_path" do
    it "is the self employment page path" do
      expect(subject.next_path).to eq(
        "/steps/medicaid/income-self-employment",
      )
    end
  end

  describe "#edit" do
    context "medicaid app has multiple members" do
      context "medicaid app has employed members" do
        it "renders edit" do
          medicaid_application = create(
            :medicaid_application,
            employed: true,
            members: create_list(:member, 2),
          )

          session[:medicaid_application_id] = medicaid_application.id

          get :edit

          expect(response).to render_template(:edit)
        end
      end

      context "medicaid app does not have emplpyed members" do
        it "redirects to the next page" do
          medicaid_application = create(
            :medicaid_application,
            employed: false,
            members: create_list(:member, 2),
          )

          session[:medicaid_application_id] = medicaid_application.id

          get :edit

          expect(response).to redirect_to(subject.next_path)
        end
      end
    end

    context "medicaid app has a single member" do
      it "redirects to the next page" do
        medicaid_application = create(
          :medicaid_application,
          members: [create(:member)],
        )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to redirect_to(subject.next_path)
      end
    end
  end
end
