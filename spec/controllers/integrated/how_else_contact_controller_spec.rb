require "rails_helper"

RSpec.describe Integrated::HowElseContactController do
  describe "#edit" do
    context "with a current application" do
      it "assigns existing attributes" do
        current_app = create(:common_application,
                             sms_consented: "yes",
                             email_consented: "no")
        session[:current_application_id] = current_app.id

        get :edit

        form = assigns(:form)
        expect(form.sms_consented).to eq("yes")
        expect(form.email_consented).to eq("no")
      end
    end
  end

  describe "#update" do
    context "with valid params" do
      let(:valid_params) do
        {
          sms_consented: "yes",
          email_consented: "no",
        }
      end

      it "updates the models" do
        current_app = create(:common_application)
        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        current_app.reload

        expect(current_app.sms_consented_yes?).to be_truthy
        expect(current_app.email_consented_no?).to be_truthy
      end
    end
  end
end
