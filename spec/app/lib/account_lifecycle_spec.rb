require 'rails_helper'

describe AccountLifecycle do
  describe "create" do
    it "contains the created account" do
      account = described_class.create(email: 'bob@example.com', password: mom.valid_password).account
      expect(account).to be_persisted
      expect(account.email).to eq 'bob@example.com'
      expect(Account.authenticate('bob@example.com', mom.valid_password)).to eq account
    end

    it "returns an unpersisted account if it is invalid" do
      account = described_class.create(email: 'bob@example.com', password: '').account
      expect(account).not_to be_persisted
    end

    it "requires password" do
      account = described_class.create(email: 'bob@example.com').account
      expect(account).not_to be_persisted
    end
  end

  describe "from_reset_token" do
    it "is successful" do
      account = create(:account)
      account.deliver_reset_password_instructions!
      lifecycle = described_class.from_reset_token(account.reset_password_token)
      expect(lifecycle).to be_found
    end

    it "fails if account cannot be found" do
      lifecycle = described_class.from_reset_token('not-a-valid-reset-token')
      expect(lifecycle).not_to be_found
    end
  end

  describe "reset_password?" do
    it "is successful" do
      account = create(:account)
      account.deliver_reset_password_instructions!
      lifecycle = described_class.new(account)
      expect(lifecycle).to be_reset_password(mom.valid_password + "1")
    end

    it "fails if password is invalid" do
      account = create(:account)
      account.deliver_reset_password_instructions!
      lifecycle = described_class.new(account)
      expect(lifecycle).not_to be_reset_password ""
    end
  end
end
