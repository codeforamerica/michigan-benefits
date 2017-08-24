require "rails_helper"

RSpec.shared_examples "param validation" do
  before { session[:snap_application_id] = current_app.id }

  describe "#update" do
    context "invalid params" do
      it "renders edit" do
        put :update, params: invalid_params

        expect(step).to be_an_instance_of(step_class)
        expect(response).to render_template(:edit)
      end
    end
  end
end
