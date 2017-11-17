require "rails_helper"

RSpec.describe Medicaid::IntroCaretakerController do
  include_examples "application required"

  it "is the intro citizen path" do
    expect(subject.next_path).to eq(
      "/steps/medicaid/intro-caretaker-member",
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
      it "renders edit" do
        medicaid_application = create(
          :medicaid_application,
            members: create_list(:member, 2),
        )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to render_template(:edit)
      end
    end
  end
end
