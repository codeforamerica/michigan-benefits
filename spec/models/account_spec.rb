require "rails_helper"

RSpec.describe Account do
  describe "validations" do
    context "when account type is a permitted type" do
      it "is valid" do
        checking_account = build(:account, account_type: "checking")
        savings_account = build(:account, account_type: "savings")
        payroll_benefits_account = build(:account, account_type: "payroll_benefits")

        expect(checking_account.valid?).to be_truthy
        expect(savings_account.valid?).to be_truthy
        expect(payroll_benefits_account.valid?).to be_truthy
      end
    end

    context "when account type not in permitted types" do
      it "is invalid" do
        account = build(:account, account_type: "foo")

        expect(account.valid?).to be_falsey
      end
    end

    context "when account type not included" do
      it "is invalid" do
        account = build(:account, account_type: nil)

        expect(account.valid?).to be_falsey
      end
    end
  end

  describe "scopes" do
    describe ".cash" do
      it "returns cash accounts" do
        build(:account, account_type: "401k")
        cash = create(:account, account_type: "checking")

        expect(Account.cash.count).to eq(1)
        expect(Account.cash).to match_array([cash])
      end
    end
    describe ".other" do
      it "returns other accounts" do
        build(:account, account_type: "checking")
        other = create(:account, account_type: "401k")

        expect(Account.other.count).to eq(1)
        expect(Account.other).to match_array([other])
      end
    end
  end
end
