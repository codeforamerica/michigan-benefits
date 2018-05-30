require "rails_helper"

RSpec.shared_examples_for "multi member only controller" do
  context "when single member household" do
    it "returns true" do
      application = create(:common_application, :single_member)

      skip_step = controller.class.skip?(application)
      expect(skip_step).to be_truthy
    end
  end
end
