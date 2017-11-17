require "rails_helper"

RSpec.shared_examples "step controller" do
  before { session[:snap_application_id] = current_app.id }

  describe "#edit" do
    it "assigns the correct step" do
      get :edit

      expect(step).to be_an_instance_of step_class
    end

    context "no application is currently under way" do
      it "redirects to the homepage" do
        if subject.class != IntroduceYourselfController
          session[:snap_application_id] = nil

          get :edit

          expect(response).to redirect_to(introduce_yourself_steps_path)
        end
      end
    end
  end

  describe "#update" do
    context "when there is no application under way" do
      it "redirects to the homepage on a PUT" do
        session[:snap_application_id] = nil

        put :update, params: {}

        if request.path == "/steps/introduce-yourself"
          expect(response).to render_template(:edit)

        elsif request.path.include? "/medicaid"
          expect(response).to redirect_to(root_path)

        else
          expect(response).to redirect_to("/steps/introduce-yourself")
        end
      end
    end
  end
end
