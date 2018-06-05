require "rails_helper"

RSpec.describe Integrated::AnythingElseController do
  describe "#skip?" do
    it "returns false" do
      application = create(:common_application)

      skip_step = Integrated::AnythingElseController.skip?(application)
      expect(skip_step).to be_falsey
    end
  end

  describe "edit" do
    context "with a current application" do
      it "assigns existing attributes and renders edit" do
        current_app = create(:common_application, additional_information: "Salient details")
        session[:current_application_id] = current_app.id

        get :edit

        form = assigns(:form)

        expect(form.additional_information).to eq("Salient details")
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "#update" do
    context "with valid params" do
      let(:valid_params) do
        {
          additional_information: "Salient details",
        }
      end

      it "updates the models" do
        current_app = create(:common_application)
        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        current_app.reload

        expect(current_app.additional_information).to eq("Salient details")
      end
    end
  end
end
