require "rails_helper"

describe StepsController do
  describe "#show", :member do
    it "shows the right step" do
      get :show, params: { id: "introduce-yourself" }
      expect(assigns(:step)).to be_an_instance_of IntroductionIntroduceYourself
    end
  end

  describe "#update", :member do
    it "saves the answers to the questions" do
      post :update, params: {
        id: "introduce-yourself",
        step: { first_name: "Alice", last_name: "Aardvark" }
      }

      app = @member.app.reload

      expect(app.first_name).to eq "Alice"
      expect(app.last_name).to eq "Aardvark"

      expect(response).to redirect_to step_path("contact-information")
    end
  end
end
