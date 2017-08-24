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

          expect(response).to redirect_to(root_path)
        end
      end
    end
  end
end
