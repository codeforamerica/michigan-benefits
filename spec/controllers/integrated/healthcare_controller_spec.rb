require "rails_helper"

RSpec.describe Integrated::HealthcareController do
  describe "#skip?" do
    context "when single-member household" do
      it "returns true" do
        application = create(:common_application, :single_member)

        skip_step = Integrated::HealthcareController.skip?(application)
        expect(skip_step).to eq(true)
      end
    end

    context "when multi-member household" do
      context "when applying for healthcare" do
        it "returns false" do
          application = create(:common_application, :multi_member_healthcare)

          skip_step = Integrated::HealthcareController.skip?(application)
          expect(skip_step).to be_falsey
        end
      end

      context "when applying for food only" do
        it "returns true" do
          application = create(:common_application, :multi_member_food)

          skip_step = Integrated::HealthcareController.skip?(application)
          expect(skip_step).to be_truthy
        end
      end
    end
  end

  describe "#update" do
    context "with valid params" do
      it "marks members as requesting healthcare" do
        current_app = create(:common_application,
          members: [create(:household_member), create(:household_member)])
        session[:current_application_id] = current_app.id

        member1 = current_app.members[0]
        member2 = current_app.members[1]

        valid_params = {
          form: {
            members: {
              member1.id => { "requesting_healthcare" => "yes" },
              member2.id => { "requesting_healthcare" => "no" },
            },
          },
        }

        put :update, params: valid_params

        current_app.reload

        expect(current_app.primary_member.requesting_healthcare_yes?).to be_truthy
        expect(current_app.members.second.requesting_healthcare_no?).to be_truthy
      end
    end
  end
end
