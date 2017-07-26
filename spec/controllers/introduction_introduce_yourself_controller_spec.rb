# frozen_string_literal: true

require "rails_helper"

RSpec.describe IntroductionIntroduceYourselfController, :member, type: :controller do
  let!(:current_app) { SnapApplication.create!(user: member) }
  let(:birthday) { DateTime.parse("2/2/1945") }

  describe "#edit" do
    before { current_app.update(name: "bob", birthday: birthday) }

    it "assigns the correct step" do
      get :edit
      expect(assigns(:step)).to be_an_instance_of IntroductionIntroduceYourself
    end

    it "assigns the name to the step" do
      get :edit
      expect(assigns(:step).name).to eq("bob")
    end

    it "assigns the birthday to the step" do
      get :edit
      expect(assigns(:step).birthday).to eq(birthday)
    end
  end

  describe "#update" do
    it "updates the applicant if the step is valid" do
      expect do
        put :update, params: {
          step: {
            name: "bob",
            "birthday(3i)" => "31",
            "birthday(2i)" => "1",
            "birthday(1i)" => "1950",
          },
        }
      end.to(
        change { current_app.reload.attributes.slice("name", "birthday") },
      )
    end

    it "redirects to the next step if the step is valid" do
      put :update, params: {
        step: {
          name: "bob",
          "birthday(3i)" => "31",
          "birthday(2i)" => "1",
          "birthday(1i)" => "1950",
        },
      }

      expect(response).to redirect_to("/steps/introduction-contact-information")
    end

    it "renders edit if the step is invalid" do
      put :update, params: { step: { name: nil } }

      expect(assigns(:step)).to be_an_instance_of(IntroductionIntroduceYourself)
      expect(response).to render_template(:edit)
    end
  end
end
