require "rails_helper"

describe StepsController do
  describe "#show", :member do
    it "shows the right step" do
      get :show, params: { id: "introduction-introduce-yourself" }
      expect(assigns(:step)).to be_an_instance_of IntroductionIntroduceYourself
    end
  end

  describe "#update", :member do
    it "saves the answers to the questions" do
      post :update, params: {
        id: "introduction-introduce-yourself",
        step: { first_name: "Alice", last_name: "Aardvark" }
      }

      app = @member.app.reload

      expect(app.applicant.first_name).to eq "Alice"
      expect(app.applicant.last_name).to eq "Aardvark"

      expect(response).to redirect_to step_path("introduction-contact-information")
    end
  end
end
