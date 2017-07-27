# frozen_string_literal: true

require "rails_helper"

RSpec.describe PersonalDetailController do
  let(:birthday) { DateTime.parse("2/2/1945") }

  describe "#edit" do
    it "assigns the correct step" do
      current_app = SnapApplication.create
      session[:snap_application_id] = current_app.id

      get :edit

      expect(assigns(:step)).to be_an_instance_of PersonalDetail
    end

    it "assigns the name to the step" do
      current_app = SnapApplication.create(name: "bob")
      session[:snap_application_id] = current_app.id

      get :edit

      expect(assigns(:step).name).to eq("bob")
    end

    it "assigns the birthday to the step" do
      current_app = SnapApplication.create(birthday: birthday)
      session[:snap_application_id] = current_app.id

      get :edit
      expect(assigns(:step).birthday).to eq(birthday)
    end
  end

  describe "#update" do
    it "updates the applicant if the step is valid" do
      current_app = SnapApplication.create(name: "Joe", birthday: birthday)
      session[:snap_application_id] = current_app.id

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

      expect(response).to redirect_to("/steps/address")
    end

    it "renders edit if the step is invalid" do
      put :update, params: { step: { name: nil } }

      expect(assigns(:step)).to be_an_instance_of(PersonalDetail)
      expect(response).to render_template(:edit)
    end
  end
end
