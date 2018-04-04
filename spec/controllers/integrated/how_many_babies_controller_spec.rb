require "rails_helper"

RSpec.describe Integrated::HowManyBabiesController do
  describe "#skip?" do
    context "when no one is pregnant" do
      it "returns true" do
        application = create(:common_application,
          navigator: build(:application_navigator, anyone_pregnant: false))

        skip_step = Integrated::HowManyBabiesController.skip?(application)
        expect(skip_step).to be_truthy
      end
    end

    context "when someone is pregnant" do
      it "returns false" do
        application = create(:common_application,
          navigator: build(:application_navigator, anyone_pregnant: true))

        skip_step = Integrated::HowManyBabiesController.skip?(application)
        expect(skip_step).to be_falsey
      end
    end
  end

  describe "edit" do
    context "with a current application" do
      it "defaults for first pregnant member" do
        primary_member = build(:household_member, pregnant: "no")
        pregnant_member = build(:household_member, pregnant: "yes")

        current_app = create(:common_application,
          navigator: build(:application_navigator, anyone_pregnant: true),
          members: [primary_member, pregnant_member])

        session[:current_application_id] = current_app.id

        get :edit, params: {}

        expect(assigns[:form].id).to eq(pregnant_member.id)
      end

      it "finds member from querystring" do
        primary_member = build(:household_member, pregnant: "no")
        pregnant_member = build(:household_member, pregnant: "yes")

        current_app = create(
          :common_application,
          navigator: build(:application_navigator, anyone_pregnant: true),
          members: [primary_member, pregnant_member],
        )

        session[:current_application_id] = current_app.id

        get :edit, params: { member: pregnant_member.id }

        expect(assigns[:form].id).to eq(pregnant_member.id)
      end
    end
  end

  describe "#update" do
    context "with valid params" do
      let(:valid_params) do
        {
          baby_count: "4",
        }
      end

      it "updates the models" do
        pregnant_member = build(:household_member, pregnant: "yes")

        current_app = create(
          :common_application,
          navigator: build(:application_navigator, anyone_pregnant: true),
          members: [pregnant_member],
        )

        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        pregnant_member.reload

        expect(pregnant_member.baby_count).to eq(4)
      end
    end

    context "with invalid params" do
      let(:invalid_params) do
        {
          baby_count: "0",
        }
      end

      it "renders edit without updating" do
        pregnant_member = build(:household_member, pregnant: "yes")

        current_app = create(
          :common_application,
          navigator: build(:application_navigator, anyone_pregnant: true),
          members: [pregnant_member],
        )

        session[:current_application_id] = current_app.id

        put :update, params: { form: invalid_params }

        expect(response).to render_template(:edit)
      end
    end
  end
end
