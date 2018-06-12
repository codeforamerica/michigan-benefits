require "rails_helper"

RSpec.describe FormsController do
  describe "#index" do
    context "when an application has been started" do
      it "renders the index page" do
        current_app = create(:common_application)
        session[:current_application_id] = current_app.id

        get :index

        expect(response).to render_template(:index)
      end
    end
  end

  describe ".skip?" do
    it "defaults to false" do
      expect(FormsController.skip?(double("foo"))).to eq(false)
    end
  end

  describe "#application_title" do
    context "when no application present yet" do
      it "returns a string for all programs" do
        expect(controller.application_title).to eq("Food Assistance + Healthcare Coverage")
      end
    end

    context "when only applying for food assistance" do
      it "returns Food Assistance" do
        current_app = create(:common_application,
                             navigator: build(:application_navigator, applying_for_food: true))
        session[:current_application_id] = current_app.id

        expect(controller.application_title).to eq("Food Assistance")
      end
    end

    context "when only applying for healthcare coverage" do
      it "returns Healthcare Coverage" do
        current_app = create(:common_application,
                             navigator: build(:application_navigator, applying_for_healthcare: true))
        session[:current_application_id] = current_app.id

        expect(controller.application_title).to eq("Healthcare Coverage")
      end
    end

    context "when only applying for all programs" do
      it "returns Food Assistance + Healthcare Coverage" do
        current_app = create(:common_application,
                             navigator: build(:application_navigator,
                                              applying_for_healthcare: true,
                                              applying_for_food: true))
        session[:current_application_id] = current_app.id

        expect(controller.application_title).to eq("Food Assistance + Healthcare Coverage")
      end
    end
  end
end
