require "rails_helper"

RSpec.describe Integrated::AuthorizedRepController do
  describe "#update" do
    context "with valid params" do
      let(:valid_params) do
        { authorized_representative: true }
      end

      it "updates the models" do
        current_app = create(:common_application)
        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        current_app.reload
        expect(current_app.authorized_representative).to be_truthy
      end
    end
  end
end
