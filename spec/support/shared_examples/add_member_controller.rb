require "rails_helper"

RSpec.shared_examples_for "add member controller" do |additional_valid_params|
  describe ".valid_relationship_options" do
    context "with one spouse household member" do
      it "does not include spouse as relationship option" do
        current_app = create(:common_application,
          members: [create(:household_member, relationship: "spouse")])

        session[:current_application_id] = current_app.id

        expect(controller.valid_relationship_options).to_not include(
          ["Spouse", "spouse"],
        )
      end
    end

    context "with no spouse household members" do
      it "includes spouse as relationship option" do
        current_app = create(:common_application)

        session[:current_application_id] = current_app.id

        expect(controller.valid_relationship_options).to include(
          ["Spouse", "spouse"],
        )
      end
    end
  end

  describe "#update" do
    context "with valid params" do
      let(:base_valid_params) do
        {
          first_name: "Gary",
          last_name: "McTester",
          birthday_day: "31",
          birthday_month: "1",
          birthday_year: "1950",
          sex: "male",
          relationship: "roommate",
        }
      end

      let(:additional_params) do
        additional_valid_params || {}
      end

      let(:valid_params) do
        base_valid_params.merge(additional_params)
      end

      it "creates a new member with given information" do
        current_app = create(:common_application,
          members: [create(:household_member, first_name: "Juan")])
        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        current_app.reload
        new_member = current_app.members.second

        expect(current_app.members.count).to eq(2)
        expect(new_member.first_name).to eq("Gary")
        expect(new_member.last_name).to eq("McTester")
        expect(new_member.birthday).to eq(DateTime.new(1950, 1, 31))
        expect(new_member.sex).to eq("male")
        expect(new_member.relationship).to eq("roommate")
      end

      context "when spouse indicated as relationship for any member" do
        let(:spouse_params) do
          valid_params.merge(relationship: "spouse")
        end

        it "updates primary member and spouse to married" do
          current_app = create(:common_application,
            navigator: build(:application_navigator),
            members: [create(:household_member)])
          session[:current_application_id] = current_app.id

          put :update, params: { form: spouse_params }

          current_app.reload

          expect(current_app.primary_member.married_yes?).to eq(true)
          expect(current_app.members.second.married_yes?).to eq(true)
        end

        it "updates navigator" do
          current_app = create(:common_application,
            navigator: build(:application_navigator),
            members: [create(:household_member)])
          session[:current_application_id] = current_app.id

          expect do
            put :update, params: { form: spouse_params }
          end.to change {
            current_app.reload
            current_app.navigator.anyone_married?
          }.to eq(true)
        end
      end
    end

    context "with invalid params" do
      let(:invalid_params) do
        {
          first_name: nil,
        }
      end

      it "renders edit without updating" do
        current_app = create(:common_application)
        session[:current_application_id] = current_app.id

        put :update, params: { form: invalid_params }

        expect(response).to render_template(:edit)
      end
    end
  end
end
