require "rails_helper"

RSpec.describe Integrated::WelcomeController do
  describe "#edit" do
    context "without a current application" do
      it "renders edit" do
        get :edit

        expect(response).to render_template(:edit)
      end
    end
  end

  describe "#update" do
    context "when application and navigator do not yet exist" do
      it "creates them and sets attribute on navigator" do
        put :update

        current_app = CommonApplication.find(session[:current_application_id])
        expect(current_app.navigator.present?).to eq(true)
      end
    end

    context "when application and navigator already exist" do
      it "does nothing" do
        current_app = create(:common_application)
        session[:current_application_id] = current_app.id

        expect do
          put :update
          current_app.reload
        end.to_not(change { current_app })
      end
    end
  end
end
