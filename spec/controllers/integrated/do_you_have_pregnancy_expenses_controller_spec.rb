require "rails_helper"

RSpec.describe Integrated::DoYouHavePregnancyExpensesController do
  describe "#skip?" do
    context "when household has one member" do
      it "returns false" do
        application = create(:common_application, members: build_list(:household_member, 1))

        skip_step = Integrated::DoYouHavePregnancyExpensesController.skip?(application)
        expect(skip_step).to be_falsey
      end
    end

    context "when household has more than one member" do
      it "returns true" do
        application = create(:common_application, members: build_list(:household_member, 2))

        skip_step = Integrated::DoYouHavePregnancyExpensesController.skip?(application)
        expect(skip_step).to be_truthy
      end
    end
  end

  describe "#update" do
    context "with valid params" do
      let(:valid_params) do
        {
          pregnancy_expenses: "no",
        }
      end

      it "updates the member and navigator" do
        current_app = create(:common_application,
          :single_member,
          navigator: build(:application_navigator, anyone_pregnancy_expenses: true))
        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        current_app.reload

        expect(current_app.primary_member.pregnancy_expenses_no?).to be_truthy
        expect(current_app.navigator.anyone_pregnancy_expenses?).to be_falsey
      end
    end
  end
end
