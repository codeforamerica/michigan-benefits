require "rails_helper"

RSpec.describe Medicaid::HealthPregnancyController, type: :controller do
  describe "#next_path" do
    it "is the  path" do
      expect(subject.next_path).to eq "/steps/medicaid/health-pregnancy-member"
    end
  end

  describe "#edit" do
    context "members are all male" do
      it "redirects to the next page" do
        medicaid_application = create(:medicaid_application)
        create(
          :member,
          sex: "male",
          benefit_application: medicaid_application,
        )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to redirect_to(subject.next_path)
      end
    end

    context "members include a female" do
      it "renders :edit" do
        medicaid_application = create(:medicaid_application)
        create(
          :member,
          sex: "female",
          benefit_application: medicaid_application,
        )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to render_template(:edit)
      end

      it "assigns members to step" do
        member = build(:member, sex: "female")
        medicaid_application = create(:medicaid_application, members: [member])
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(assigns[:step].members).to eq [member]
      end
    end
  end

  describe "#update" do
    context "multi member household, one female membrer" do
      context "someone is pregnant" do
        it "updates the member" do
          female_member = build(:member, sex: "female")
          male_member = build(:member, sex: "male")

          medicaid_application = create(
            :medicaid_application,
            members: [male_member, female_member],
          )
          session[:medicaid_application_id] = medicaid_application.id

          put :update, params: { step: { anyone_new_mom: true } }

          female_member.reload
          male_member.reload

          expect(female_member).to be_new_mom
          expect(male_member).not_to be_new_mom
        end
      end
    end

    context "single member household" do
      context "someone is pregnant" do
        it "updates the member" do
          member = build(:member)

          medicaid_application = create(
            :medicaid_application,
            members: [member],
          )
          session[:medicaid_application_id] = medicaid_application.id

          put :update, params: { step: { anyone_new_mom: true } }

          member.reload

          expect(member).to be_new_mom
        end
      end

      context "nobody pregnant" do
        it "updates the member" do
          member = build(:member)

          medicaid_application = create(
            :medicaid_application,
            members: [member],
          )
          session[:medicaid_application_id] = medicaid_application.id

          put :update, params: { step: { anyone_new_mom: false } }

          member.reload

          expect(member).not_to be_new_mom
        end
      end
    end
  end
end
