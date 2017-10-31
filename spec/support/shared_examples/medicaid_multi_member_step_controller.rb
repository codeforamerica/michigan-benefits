require "rails_helper"

RSpec.shared_examples_for "Medicaid multi-member controller" do |medicaid_attr|
  describe "#edit" do
    context "multi-member household" do
      context "attribute is false" do
        it "skips this page" do
          medicaid_application = create(
            :medicaid_application,
            members: create_list(:member, 2),
            medicaid_attr => false,
          )
          session[:medicaid_application_id] = medicaid_application.id

          get :edit

          expect(response).to redirect_to(subject.next_path)
        end
      end

      context "attribute is true" do
        it "renders :edit" do
          medicaid_application = create(
            :medicaid_application,
            members: create_list(:member, 2),
            medicaid_attr => true,
          )
          session[:medicaid_application_id] = medicaid_application.id

          get :edit

          expect(response).to render_template(:edit)
        end
      end
    end

    context "single member household" do
      context "attribute is true" do
        it "skips this page" do
          medicaid_application = create(
            :medicaid_application,
            members: [create(:member)],
            medicaid_attr => true,
          )
          session[:medicaid_application_id] = medicaid_application.id

          get :edit

          expect(response).to redirect_to(subject.next_path)
        end
      end

      context "attribute is false" do
        it "skips the page" do
          medicaid_application = create(
            :medicaid_application,
            members: [create(:member)],
            medicaid_attr => false,
          )
          session[:medicaid_application_id] = medicaid_application.id

          get :edit

          expect(response).to redirect_to(subject.next_path)
        end
      end
    end
  end
end
