require "rails_helper"

RSpec.describe Integrated::<%= model.camelcase %>Controller do
  describe "edit" do
    context "with a current application" do
      xit "assigns existing attributes" do
        current_app = create(:common_application)
        session[:current_application_id] = current_app.id

        get :edit

        form = assigns(:form)

        # expectation
      end
    end

    context "without a current application" do
      it "renders edit" do
        get :edit

        expect(response).to render_template(:edit)
      end
    end
  end

  describe "#update" do
    context "with valid params" do
      let(:valid_params) do
        { }
      end

      xit "updates the models" do
        current_app = create(:common_application)
        session[:current_application_id] = current_app.id

        put :update, params: valid_params

        current_app.reload

        # expectation
      end
    end

    context "with invalid params" do
      let(:invalid_params) do
        { }
      end

      xit "renders edit without updating" do
        current_app = create(:common_application)
        session[:current_application_id] = current_app.id

        put :update, params: invalid_params

        expect(response).to render_template(:edit)
      end
    end
  end
end
