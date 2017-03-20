require "rails_helper"

describe StepsController do
  describe "#show", :member do
    it "shows the right step" do
      get :show, params: { id: "introduce-yourself" }
      expect(assigns(:step)).to be_an_instance_of IntroduceYourself
    end
  end

  describe "#update", :member do
    it "saves the answers to the questions" do
      post :update, params: {
        id: "introduce-yourself",
        step: { first_name: "Alice", last_name: "Aardvark", phone_number: "415-867-5309", accept_text_messages: "false" }
      }

      app = @member.app.reload

      expect(app.first_name).to eq "Alice"
      expect(app.last_name).to eq "Aardvark"
      expect(app.phone_number).to eq "415-867-5309"
      expect(app.accepts_text_messages).to eq false

      expect(response).to redirect_to step_path("choose-programs")
    end
  end
end
