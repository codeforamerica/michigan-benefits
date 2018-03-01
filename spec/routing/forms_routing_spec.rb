require "rails_helper"

RSpec.describe FormsController do
  describe "in production" do
    before do
      allow(Rails).to receive(:env).
        and_return(ActiveSupport::StringInquirer.new("production"))

      MichiganBenefits::Application.reload_routes!
    end

    after do
      allow(Rails).to receive(:env).and_call_original
      MichiganBenefits::Application.reload_routes!
    end

    it "rejects sections path and subpaths" do
      expect(get: "/sections").not_to be_routable
      expect(get: "/sections/before-you-start").not_to be_routable
    end
  end
end
