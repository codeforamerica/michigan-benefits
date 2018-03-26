require "rails_helper"

RSpec.describe Integrated::AddHouseholdMemberController do
  it_behaves_like "add member controller"

  describe "#update" do
    context "with valid params" do
      let(:valid_params) do
        {
          form: {
            first_name: "Gary",
            last_name: "McTester",
            birthday_day: "31",
            birthday_month: "1",
            birthday_year: "1950",
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

    context "with minimal valid params" do
      let(:valid_params) do
        {
          form: {
            first_name: "Gary",
            last_name: "McTester",
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
        expect(new_member.birthday).to be_nil
        expect(new_member.sex).to eq("unfilled")
        expect(new_member.relationship).to eq("unknown_relation")
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
