require "rails_helper"

RSpec.describe IntroduceYourselfController do
  let(:step) { assigns(:step) }
  let(:invalid_params) { { step: { first_name: nil } } }
  let(:step_class) { IntroduceYourself }

  before { session[:snap_application_id] = current_app.id }

  include_examples "step controller", "param validation"

  describe "#edit" do
    context "office location in params" do
      it "assigns office location" do
        get :edit, params: { office_location: "clio" }

        expect(step.office_location).to eq "clio"
      end
    end

    it "assigns the name and birthday to the step" do
      get :edit

      expect(step.first_name).to eq("bob")
      expect(step.last_name).to eq("booboo")
      expect(step.birthday).to eq(birthday)
    end

    context "application has not yet been created" do
      it "does not redirect to the homepage" do
        session[:snap_application_id] = nil

        get :edit

        expect(response).to render_template(:edit)
      end
    end
  end

  describe "#update" do
    context "name contains leading or trailing whitespace" do
      it "strips whitespace" do
        params = {
          step: {
            first_name: " Space ",
            last_name: " Case ",
            "birthday(3i)" => "31",
            "birthday(2i)" => "1",
            "birthday(1i)" => "1950",
          },
        }

        put :update, params: params
        member.reload

        expect(member.first_name).to eq "Space"
        expect(member.last_name).to eq "Case"
      end
    end

    context "no office location present" do
      context "valid params" do
        it "updates the application" do
          expect do
            put :update, params: valid_params
          end.to(
            change do
              current_app.primary_member.reload.attributes.slice(
                "first_name",
                "last_name",
                "birthday",
              )
            end,
          )
        end

        it "redirects to the next step" do
          put :update, params: valid_params

          expect(response).to redirect_to("/steps/contact-information")
        end
      end
    end

    context "office location present" do
      it "updates the office location for the snap application" do
        params = { step: {
          first_name: "RJ",
          last_name: "D2",
          "birthday(3i)" => "31",
          "birthday(2i)" => "1",
          "birthday(1i)" => "1950",
          office_location: "union",
        } }

        put :update, params: params

        expect(current_app.reload.office_location).to eq "union"
      end
    end
  end

  def current_app
    @_current_app ||= create(:snap_application, members: [member])
  end

  def member
    @_member ||= build(
      :member,
      first_name: "bob",
      last_name: "booboo",
      birthday: birthday,
    )
  end

  def valid_params
    {
      step: {
        first_name: "RJ",
        last_name: "D2",
        "birthday(3i)" => "31",
        "birthday(2i)" => "1",
        "birthday(1i)" => "1950",
      },
    }
  end

  def birthday
    DateTime.parse("2/2/1945")
  end
end
