require "rails_helper"

RSpec.describe Integrated::AddHouseholdMemberController do
  describe "#update" do
    context "with valid params" do
      let(:valid_params) do
        {
          form: {
            first_name: "Gary",
            last_name: "McTester",
            "birthday(3i)" => "31",
            "birthday(2i)" => "1",
            "birthday(1i)" => "1950",
            sex: "male",
            relationship: "roommate",
          },
        }
      end

      it "creates a new member with given information" do
        current_app = create(:common_application,
          members: [create(:household_member, first_name: "Juan")])
        session[:current_application_id] = current_app.id

        put :update, params: valid_params

        current_app.reload

        new_member = current_app.members.last
        expect(new_member.first_name).to eq("Gary")
        expect(new_member.last_name).to eq("McTester")
        expect(new_member.birthday).to eq(DateTime.new(1950, 1, 31))
        expect(new_member.sex).to eq("male")
        expect(new_member.relationship).to eq("roommate")
      end
    end
  end

  describe ".previous_path" do
    it "should be household overview path" do
      expect(controller.previous_path).to eq(household_members_overview_sections_path)
    end
  end

  describe ".next_path" do
    it "should be household overview path" do
      expect(controller.next_path).to eq(household_members_overview_sections_path)
    end
  end
end
