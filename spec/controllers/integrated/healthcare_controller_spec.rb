require "rails_helper"

RSpec.describe Integrated::HealthcareController do
  describe "#skip?" do
    context "when single-member household" do
      it "returns true and marks primary member as applying for healthcare" do
        application = create(:common_application, :single_member)

        skip_step = Integrated::HealthcareController.skip?(application)
        expect(skip_step).to eq(true)
      end

      it "marks primary member as applying for healthcare" do
        application = create(:common_application, :single_member)

        expect { Integrated::HealthcareController.skip?(application) }.
          to change { application.primary_member.requesting_healthcare }.from("unfilled").to("yes").
          and change { application.healthcare_applying_members.count }.by(1)
      end
    end
  end

  describe "#update" do
    context "with valid params" do
      it "marks members as requesting food" do
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
