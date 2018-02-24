require "rails_helper"

RSpec.describe Medicaid::PaperworkIncomeProofController do
  describe "assigned step" do
    it "defaults for first member with income" do
      primary_member = build(:member, employed: false)
      employed_member = build(:member, employed: true)
      medicaid_application = create(
        :medicaid_application,
        anyone_employed: true,
        members: [primary_member, employed_member],
      )

      session[:medicaid_application_id] = medicaid_application.id

      get :edit, params: {}

      expect(assigns[:step].id).to eq employed_member.id
    end
  end

  describe "#edit" do
    context "single member household" do
      context "without income" do
        it "skips this page" do
          medicaid_application = create(
            :medicaid_application,
            members: [build(:member)],
          )

          session[:medicaid_application_id] = medicaid_application.id

          get :edit

          expect(response).to redirect_to(subject.next_path)
        end
      end
      context "with income" do
        it "shows this page" do
          primary_member = build(:member, employed: true)
          medicaid_application = create(
            :medicaid_application,
            members: [primary_member],
            anyone_employed: true,
          )

          session[:medicaid_application_id] = medicaid_application.id

          get :edit

          expect(assigns[:step].id).to eq primary_member.id
        end
      end
    end

    context "multi member household" do
      context "someone has income" do
        it "renders :edit" do
          medicaid_application = create(
            :medicaid_application,
            anyone_employed: true,
            members: build_list(:member, 2, employed: true),
          )
          session[:medicaid_application_id] = medicaid_application.id

          get :edit

          expect(response).to render_template(:edit)
        end
      end

      context "nobody has income" do
        it "skips this page" do
          medicaid_application = create(
            :medicaid_application,
            anyone_employed: false,
          )
          build_list(:member, 2, benefit_application: medicaid_application)
          session[:medicaid_application_id] = medicaid_application.id

          get :edit

          expect(response).to redirect_to(subject.next_path)
        end
      end
    end
  end

  describe "#update" do
    context "single member household" do
      it "sets a value for has_proof_of_income" do
        medicaid_application = create(
          :medicaid_application,
          anyone_employed: true,
        )
        primary_member = create(
          :member,
          benefit_application: medicaid_application,
          employed: true,
        )
        session[:medicaid_application_id] = medicaid_application.id

        put(
          :update,
          params: {
            step: {
              id: primary_member.id,
              has_proof_of_income: "today",
            },
          },
        )
        primary_member.reload

        expect(primary_member.has_proof_of_income_today?).to be_truthy
      end
    end

    context "two-member household" do
      before(:each) do
        @medicaid_application = create(
          :medicaid_application,
          anyone_employed: true,
        )
        @first_member = create(
          :member,
          benefit_application: @medicaid_application,
          employed: true,
        )
        @second_member = create(
          :member,
          benefit_application: @medicaid_application,
          employed: true,
        )
        session[:medicaid_application_id] = @medicaid_application.id
      end

      it "updates has_proof_of_income for the first member and redirect to next member" do
        put(
          :update,
          params: {
            step: { id: @first_member.id, has_proof_of_income: "today" },
          },
        )

        @first_member.reload
        expect(@first_member.has_proof_of_income_today?).to be_truthy
        expect(subject.next_path).to include("member=#{@second_member.id}")
        expect(response).to redirect_to(subject.next_path)
      end

      it "updates has_proof_of_income for the second member and redirects to next step" do
        put(
          :update,
          params: {
            step: { id: @second_member.id, has_proof_of_income: "soon" },
          },
        )
        @second_member.reload
        expect(@second_member.has_proof_of_income_soon?).to be_truthy
        expect(subject.next_path).to include("/steps/medicaid/paperwork-guide")
        expect(response).to redirect_to(subject.next_path)
      end
    end
  end
end
