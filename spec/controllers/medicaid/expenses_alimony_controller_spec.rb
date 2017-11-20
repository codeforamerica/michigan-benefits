require "rails_helper"

RSpec.describe Medicaid::ExpensesAlimonyController, type: :controller do
  describe "#next_path" do
    it "is the student loan expenses page path" do
      expect(subject.next_path).to eq "/steps/medicaid/expenses-alimony-member"
    end
  end

  describe "#update" do
    context "single member household" do
      context "anyone pays child support alimony or arrears" do
        it "updates the member" do
          member = create(:member)

          medicaid_application = create(
            :medicaid_application, members: [member]
          )
          session[:medicaid_application_id] = medicaid_application.id

          put(
            :update,
            params: {
              step: { anyone_pay_child_support_alimony_arrears: true },
            },
          )

          member.reload

          expect(member.pay_child_support_alimony_arrears).to eq true
        end
      end

      context "nobody pays child support alimony or arrears" do
        it "does not update the member" do
          member = create(:member)

          medicaid_application = create(
            :medicaid_application, members: [member]
          )
          session[:medicaid_application_id] = medicaid_application.id

          put(
            :update,
            params: {
              step: { anyone_pay_child_support_alimony_arrears: false },
            },
          )

          member.reload

          expect(member.pay_child_support_alimony_arrears).to eq false
        end
      end
    end
  end
end
