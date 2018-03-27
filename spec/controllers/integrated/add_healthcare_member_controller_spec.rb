require "rails_helper"

RSpec.describe Integrated::AddHealthcareMemberController do
  it_behaves_like "add member controller"

  describe "#update" do
    context "with valid params" do
      let(:valid_params) do
        {
          first_name: "Princess",
          last_name: "Caroline",
          relationship: "sibling",
        }
      end

      it "marks member as applying for healthcare" do
        current_app = create(:common_application)
        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        member = current_app.members.last
        expect(member.requesting_healthcare_yes?).to be_truthy
      end

      it "updates the models" do
        current_app = create(:common_application)
        session[:current_application_id] = current_app.id

        expect do
          put :update, params: { form: valid_params }
        end.to change { current_app.members.count }.by 1

        member = current_app.members.last
        expect(member.first_name).to eq("Princess")
        expect(member.last_name).to eq("Caroline")
        expect(member.relationship).to eq("sibling")
      end
    end

    context "with invalid params" do
      let(:invalid_params) do
        {
          first_name: nil,
          last_name: nil,
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

  describe ".next_path" do
    it "should be the healthcare members path" do
      expect(controller.next_path).to eq(healthcare_sections_path)
    end
  end

  describe ".previous_path" do
    it "should be the healthcare members path" do
      expect(controller.previous_path).to eq(healthcare_sections_path)
    end
  end
end
