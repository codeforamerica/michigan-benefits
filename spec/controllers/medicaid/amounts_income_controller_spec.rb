require "rails_helper"

RSpec.describe Medicaid::AmountsIncomeController do
  describe "#edit" do
    context "no one in the house has any income" do
      it "redirects to next step" do
        medicaid_application = create(
          :medicaid_application,
          anyone_employed: false,
          anyone_self_employed: false,
          anyone_other_income: false,
        )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to redirect_to("/steps/medicaid/amounts-expenses")
      end
    end

    context "a single member in the household" do
      context "current member does not have income" do
        it "redirects to next step" do
          member = build(:member, employed: false)
          medicaid_application = create(
            :medicaid_application,
            members: [member],
            anyone_employed: true,
            anyone_self_employed: false,
            anyone_other_income: false,
          )
          session[:medicaid_application_id] = medicaid_application.id

          get :edit

          expect(response).to redirect_to("/steps/medicaid/amounts-expenses")
        end
      end

      context "current member is self employed" do
        it "renders edit" do
          members = [
            build(:member, self_employed: true, employed_number_of_jobs: 0),
            build(:member, employed: true, employed_number_of_jobs: 2),
          ]
          medicaid_application = create(
            :medicaid_application,
            members: members,
            anyone_employed: true,
            anyone_self_employed: true,
            anyone_other_income: false,
          )
          session[:medicaid_application_id] = medicaid_application.id

          get :edit

          expect(response).to render_template(:edit)
        end
      end

      context "household, and a client, has income" do
        it "renders edit" do
          member = build(:member, employed: true, employed_number_of_jobs: 2)
          medicaid_application = create(
            :medicaid_application,
            members: [member],
            anyone_employed: true,
            anyone_self_employed: false,
            anyone_other_income: false,
          )
          session[:medicaid_application_id] = medicaid_application.id

          get :edit

          expect(response).to render_template(:edit)
        end

        it "assigns employments to step" do
          medicaid_application = create(
            :medicaid_application,
            anyone_employed: true,
            anyone_self_employed: false,
            anyone_other_income: false,
          )
          medicaid_application.update(
            members: [
              create(
                :member,
                employed: true,
                employed_number_of_jobs: 2,
              )
            ]
          )
          existing_employments = build_list(:employment, 2)
          medicaid_application.members.first.update(employments: existing_employments)

          session[:medicaid_application_id] = medicaid_application.id

          get :edit

          expect(response).to render_template(:edit)
          expect(assigns[:step].employments).to match_array(existing_employments)
        end
      end
    end
  end

  describe "#update" do
    context "client has multiple jobs" do
      it "saves the income for each job" do
        medicaid_application = create(
          :medicaid_application,
          anyone_employed: true,
        )
        member = build(:member, employed: true, employed_number_of_jobs: 2)
        medicaid_application.update(members: [member])
        member.update(employments: build_list(:employment, 2))
        session[:medicaid_application_id] = medicaid_application.id

        member.reload
        employment1 = member.employments.first
        employment2 = member.employments.second

        post :update, params: {
          step: {
            employments: {
              employment1.id => {
                pay_quantity: 111,
                employer_name: "Co1",
                payment_frequency: "Monthly",
              },
              employment2.id => {
                pay_quantity: 222,
                employer_name: "Co2",
                payment_frequency: "Weekly",
              },
            },
            id: member.id,
          },
        }

        employment1.reload
        employment2.reload

        expect(member.employments.reload.count).to eq 2

        expect(employment1.pay_quantity).to eq("111")
        expect(employment1.employer_name).to eq("Co1")
        expect(employment1.payment_frequency).to eq("Monthly")

        expect(employment2.pay_quantity).to eq("222")
        expect(employment2.employer_name).to eq("Co2")
        expect(employment2.payment_frequency).to eq("Weekly")
      end
    end

    context "client is self-employed with no jobs" do
      it "saves the self-employment amount" do
        member = build(
          :member,
          employed: false,
          employed_number_of_jobs: 0,
          self_employed: true,
        )
        medicaid_application = create(
          :medicaid_application,
          members: [member],
          anyone_employed: false,
        )
        session[:medicaid_application_id] = medicaid_application.id
        member.reload

        post :update, params: {
          step: {
            id: member.id,
            self_employed_monthly_income: "1234",
          },
        }

        member.reload
        expect(member.self_employed_monthly_income).to eq(1234)
      end
    end
  end
end
