require "rails_helper"

RSpec.describe Integrated::UploadPaperworkController, type: :controller do
  describe "#skip?" do
    context "when applicant is uploading paperwork" do
      it "returns false" do
        application = create(:common_application,
          navigator: build(:application_navigator, upload_paperwork: false))

        skip_step = Integrated::UploadPaperworkController.skip?(application)
        expect(skip_step).to eq(false)
      end
    end

    context "when applicant is not uploading paperwork" do
      it "returns true" do
        application = create(:common_application,
          navigator: build(:application_navigator, upload_paperwork: true))

        skip_step = Integrated::UploadPaperworkController.skip?(application)
        expect(skip_step).to eq(true)
      end
    end
  end

  describe "#edit" do
    context "with existing paperwork" do
      it "assigns paperwork" do
        application = create(:common_application,
          paperwork: [
            "paper-swan.jpg",
          ])

        session[:current_application_id] = application.id

        get :edit

        form = assigns(:form)

        expect(form.paperwork.count).to eq(1)
        expect(form.paperwork.first).to eq("paper-swan.jpg")
      end
    end
  end

  describe "#update" do
    context "with valid params" do
      let(:valid_params) do
        {
          paperwork: [
            "hello.png",
          ],
        }
      end

      it "updates the models" do
        current_app = create(:common_application)

        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        current_app.reload

        expect(current_app.paperwork).to match_array(["hello.png"])
      end
    end

    context "with empty params" do
      let(:valid_params) do
        {
          paperwork: [],
        }
      end

      it "updates the models" do
        current_app = create(:common_application, paperwork: ["woop"])

        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        current_app.reload

        expect(current_app.paperwork).to match_array([])
      end
    end
  end
end
