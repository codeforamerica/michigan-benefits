require "rails_helper"

RSpec.describe Medicaid::IncomeJobNumberMemberController do
  describe "#next_path" do
    it "is the self employment page path" do
      expect(subject.next_path).to eq(
        "/steps/medicaid/income-self-employment",
      )
    end
  end

  describe "#update" do
    it "updates the job number count and employments" do
      member1 = build(:member)
      member2 = build(:member)
      medicaid_application = create(
        :medicaid_application,
        members: [member1, member2],
      )

      session[:medicaid_application_id] = medicaid_application.id

      put :update, params: {
        step: {
          members: {
            member1.id => {
              employed_number_of_jobs: 2,
            },
            member2.id => {
              employed_number_of_jobs: 0,
            },
          },
        },
      }

      member1.reload
      member2.reload

      expect(member1.employed_number_of_jobs).to eq 2
      expect(member1.employments.count).to eq 2
      expect(member1.employed).to eq true
      expect(member2.employed_number_of_jobs).to eq 0
      expect(member2.employments.count).to eq 0
      expect(member2.employed).to eq false
    end
  end

  it_should_behave_like(
    "Medicaid multi-member controller",
    :anyone_employed,
  )
end
