require "rails_helper"

RSpec.describe Medicaid::IntroCaretakerMemberController do
  it "is the intro citizen path" do
    expect(subject.next_path).to eq(
      "/steps/medicaid/insurance-needed",
    )
  end

  describe "#edit" do
    context "single member household" do
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

    context "multi member household" do
      context "where someone is a caretaker or parent" do
        it "renders edit" do
          medicaid_application = create(
            :medicaid_application,
              anyone_caretaker_or_parent: true,
              members: create_list(:member, 2),
          )
          session[:medicaid_application_id] = medicaid_application.id

          get :edit

          expect(response).to render_template(:edit)
        end
      end

      context "where noone is a caretaker or parent" do
        it "redirects to the next page" do
          medicaid_application = create(
            :medicaid_application,
              anyone_caretaker_or_parent: false,
              members: create_list(:member, 2),
          )
          session[:medicaid_application_id] = medicaid_application.id

          get :edit

          expect(response).to redirect_to(subject.next_path)
        end
      end
    end
  end
end
