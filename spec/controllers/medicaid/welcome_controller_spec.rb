require "rails_helper"

RSpec.describe Medicaid::WelcomeController do
  describe "#edit" do
    context "application has not yet been created" do
      it "does not redirect" do
        session[:medicaid_application_id] = nil

        get :edit

        expect(response).to render_template(:edit)
      end

      context "assigning office page to the step" do
        context "when query param is not present" do
          it "assigns nil to the step" do
            get :edit

            step = assigns(:step)

            expect(step.office_page).to be_nil
          end
        end

        context "when query param is present" do
          it "assigns the query param to the step" do
            get :edit, params: { office_page: "blah" }

            step = assigns(:step)

            expect(step.office_page).to eq("blah")
          end
        end
      end
    end

    context "application has already been created" do
      context "when query param is not present" do
        it "sets office page to existing value" do
          medicaid_application = create(:medicaid_application,
            office_page: "my_office")
          session[:medicaid_application_id] = medicaid_application.id

          get :edit

          step = assigns(:step)

          expect(step.office_page).to eq("my_office")
        end
      end
    end
  end

  describe "#update" do
    context "without an existing application" do
      it "creates application with office page and assigns to session" do
        put :update, params: { step: { office_page: "my office" } }

        current_application_id = session[:medicaid_application_id]
        medicaid_application = MedicaidApplication.find(current_application_id)

        expect(medicaid_application.office_page).to eq("my office")
      end
    end

    context "with an existing application" do
      it "updates with office page" do
        medicaid_application = create(:medicaid_application)
        session[:medicaid_application_id] = medicaid_application.id

        put :update, params: { step: { office_page: "my office" } }

        medicaid_application.reload
        expect(medicaid_application.office_page).to eq("my office")
      end
    end
  end
end
