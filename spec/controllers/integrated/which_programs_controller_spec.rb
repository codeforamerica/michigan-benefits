require "rails_helper"

RSpec.describe Integrated::WhichProgramsController do
  describe "#skip?" do
    it "returns false" do
      application = create(:common_application)

      skip_step = Integrated::WhichProgramsController.skip?(application)
      expect(skip_step).to eq(false)
    end
  end

  describe "#edit" do
    context "with an existing application" do
      it "assigns existing attributes" do
        current_app = create(:common_application,
           office_page: "clio",
           navigator: build(:application_navigator,
                            applying_for_food: true,
                            applying_for_healthcare: true))

        session[:current_application_id] = current_app.id

        get :edit

        form = assigns(:form)

        expect(form.office_page).to eq("clio")
        expect(form.applying_for_food).to eq(true)
        expect(form.applying_for_healthcare).to eq(true)
      end
    end

    context "without a current application" do
      it "renders edit" do
        get :edit, params: {
          office_page: "clio",
          applying_for_food: "true",
          applying_for_healthcare: "true",
        }

        form = assigns(:form)

        expect(response).to render_template(:edit)
        expect(form.office_page).to eq("clio")
        expect(form.applying_for_food).to be_truthy
        expect(form.applying_for_healthcare).to be_truthy
      end
    end
  end

  describe "#update" do
    context "with valid params" do
      let(:valid_params) do
        {
          applying_for_food: "1",
          applying_for_healthcare: "0",
          office_page: "clio",
        }
      end

      context "when application and navigator do not yet exist" do
        it "creates them and sets attribute on navigator" do
          put :update, params: { form: valid_params }

          current_app = CommonApplication.find(session[:current_application_id])
          expect(current_app.navigator.present?).to eq(true)
          expect(current_app.office_page).to eq "clio"
        end
      end

      context "when application and navigator already exist" do
        it "updates the models" do
          current_app = create(:common_application, :with_navigator)
          session[:current_application_id] = current_app.id

          put :update, params: { form: valid_params }

          current_app.reload

          expect(current_app.navigator.applying_for_food).to eq(true)
          expect(current_app.navigator.applying_for_healthcare).to eq(false)
          expect(current_app.office_page).to eq "clio"
        end
      end
    end

    context "with invalid params" do
      let(:invalid_params) do
        {
          applying_for_food: "0",
          applying_for_healthcare: "0",
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
