require "rails_helper"

RSpec.describe Integrated::AddFoodMemberController do
  it_behaves_like "add member controller"

  describe "#update" do
    context "with valid params" do
      let(:valid_params) do
        {
          form: {
            first_name: "Gary",
            last_name: "McTester",
            relationship: "roommate",
          },
        }
      end

      it "marks new member as buying and preparing food together" do
        current_app = create(:common_application,
          members: [create(:household_member, first_name: "Juan")])
        session[:current_application_id] = current_app.id

        put :update, params: valid_params

        current_app.reload

        new_member = current_app.members.last
        expect(new_member.requesting_food).to eq("yes")
        expect(new_member.buy_and_prepare_food_together).to eq("yes")
      end
    end
  end

  describe ".previous_path" do
    it "should be household overview path" do
      expect(controller.previous_path).to eq(review_food_assistance_members_sections_path)
    end
  end

  describe ".next_path" do
    it "should be household overview path" do
      expect(controller.next_path).to eq(review_food_assistance_members_sections_path)
    end
  end
end
