require "rails_helper"

RSpec.describe Integrated::IntroduceYourselfController do
  describe "edit" do
    context "with a current application" do
      it "assigns existing attributes" do
        current_app = create(:common_application,
          members: [build(:household_member, first_name: "Juan")])
        session[:current_application_id] = current_app.id

        get :edit

        form = assigns(:form)

        expect(form.first_name).to eq("Juan")
      end
    end

    context "without a current application" do
      it "renders edit" do
        get :edit

        expect(response).to render_template(:edit)
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
            "birthday(3i)" => "31",
            "birthday(2i)" => "1",
            "birthday(1i)" => "1950",
            sex: "male",
          },
        }
      end

      context "without a current application" do
        it "creates application and assigns to session" do
          put :update, params: valid_params

          current_app = CommonApplication.find(session[:current_application_id])

          primary_member = current_app.primary_member
          expect(primary_member.first_name).to eq("Gary")
          expect(primary_member.last_name).to eq("McTester")
          expect(primary_member.sex).to eq("male")
          expect(primary_member.birthday).to eq(DateTime.new(1950, 1, 31))
        end
      end

      context "with a current application" do
        it "modifies member information" do
          current_app = create(:common_application,
            members: [build(:household_member, first_name: "Juan")])

          session[:current_application_id] = current_app.id

          put :update, params: valid_params

          expect(current_app.primary_member.first_name).to eq("Gary")
        end
      end
    end
  end
end
