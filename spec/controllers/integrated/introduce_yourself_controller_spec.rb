require "rails_helper"

RSpec.describe Integrated::IntroduceYourselfController do
  describe "edit" do
    context "with a current application" do
      it "assigns existing attributes" do
        current_app = create(:common_application,
          previously_received_assistance: "yes",
          members: [build(:household_member,
            first_name: "Juan",
            last_name: "Two",
            birthday: DateTime.new(1950, 1, 31),
            sex: "male",
            relationship: "primary")])
        session[:current_application_id] = current_app.id

        get :edit

        form = assigns(:form)

        expect(form.first_name).to eq("Juan")
        expect(form.birthday_year).to eq(1950)
        expect(form.birthday_month).to eq(1)
        expect(form.birthday_day).to eq(31)
        expect(form.previously_received_assistance).to eq("yes")
      end
    end
  end

  describe "update" do
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
            relationship: "primary",
            previously_received_assistance: "yes",
          },
        }
      end

      context "with an existing primary member" do
        it "modifies member information" do
          current_app = create(:common_application,
            :with_navigator,
            members: [create(:household_member, first_name: "Juan")])

          session[:current_application_id] = current_app.id

          put :update, params: valid_params

          current_app.reload

          primary_member = current_app.primary_member
          expect(primary_member.first_name).to eq("Gary")
          expect(primary_member.relationship).to eq("primary")
          expect(current_app.previously_received_assistance).to eq("yes")
        end
      end

      context "without an existing primary member" do
        it "draws program information from the navigator" do
          current_app = create(:common_application,
                               navigator: build(:application_navigator,
                                                applying_for_food: true,
                                                applying_for_healthcare: false))

          session[:current_application_id] = current_app.id

          put :update, params: valid_params

          current_app.reload

          expect(current_app.primary_member.requesting_food).to eq("yes")
          expect(current_app.primary_member.requesting_healthcare).to eq("no")
          expect(current_app.primary_member.buy_and_prepare_food_together).to eq("yes")
        end
      end
    end
  end
end
