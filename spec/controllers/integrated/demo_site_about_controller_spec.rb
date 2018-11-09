require "rails_helper"

RSpec.describe Integrated::DemoSiteAboutController do
  describe "#skip?" do
    context "when rails environment is demo environment" do
      it "returns false" do
        allow(GateKeeper).to receive(:demo_environment?).and_return(true)

        skip_step = Integrated::DemoSiteAboutController.skip?(nil)
        expect(skip_step).to eq(false)
      end
    end

    context "when rails environment is production environment" do
      it "returns true" do
        allow(GateKeeper).to receive(:demo_environment?).and_return(false)

        skip_step = Integrated::DemoSiteAboutController.skip?(nil)
        expect(skip_step).to eq(true)
      end
    end
  end

  describe "edit" do
    context "without a current application" do
      it "renders edit" do
        get :edit

        expect(response).to render_template(:edit)
      end
    end
  end
end
