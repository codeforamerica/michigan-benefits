require "rails_helper"

RSpec.shared_examples_for "add member controller" do
  describe ".valid_relationship_options" do
    context "with one spouse household member" do
      it "does not include spouse as relationship option" do
        current_app = create(:common_application,
          members: [create(:household_member, relationship: "spouse")])

        session[:current_application_id] = current_app.id

        expect(controller.valid_relationship_options).to_not include([
                                                                       "Spouse", "spouse"
                                                                     ])
      end
    end

    context "with no spouse household members" do
      it "includes spouse as relationship option" do
        current_app = create(:common_application)

        session[:current_application_id] = current_app.id

        expect(controller.valid_relationship_options).to include([
                                                                   "Spouse", "spouse"
                                                                 ])
      end
    end
  end
end
