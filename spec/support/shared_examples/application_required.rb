require "rails_helper"

RSpec.shared_examples "application required" do
  before { session[:snap_application_id] = nil }

  context "when there is no application under way" do
    describe "#edit" do
      it "redirects to the homepage" do
        get :edit

        if request.path == introduce_yourself_steps_path
          expect(response).to render_template(:edit)

        elsif request.path.include? "/medicaid"
          expect(response).to redirect_to("/steps/medicaid/intro-location")

        else
          expect(response).to redirect_to(introduce_yourself_steps_path)
        end
      end

      it "redirects to the homepage on a PUT" do
        put :update, params: {}

        if request.path == introduce_yourself_steps_path
          expect(response).to render_template(:edit)

        elsif request.path.include? "/medicaid"
          expect(response).to redirect_to("/steps/medicaid/intro-location")

        else
          expect(response).to redirect_to(introduce_yourself_steps_path)
        end
      end
    end
  end
end
