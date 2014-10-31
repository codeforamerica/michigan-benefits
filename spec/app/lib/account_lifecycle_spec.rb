require 'rails_helper'

describe AccountLifecycle do
  it "returns the created account" do
    account = described_class.create(email: 'bob@example.com', password: 'password')
    expect(account.email).to eq 'bob@example.com'
    expect(Account.authenticate('bob@example.com', 'password')).to eq account
  end

  it "returns an unpersisted account if it is invalid" do
    account = described_class.create(email: 'bob@example.com', password: '')
    expect(account).not_to be_persisted
  end

  it "defaults some accounts to be admins" do
    admin_role = create(:admin_role)
    stub_const('AccountLifecycle::AUTOMATICALLY_ADMINS', ['bob@example.com'].to_set)
    account = described_class.create(email: 'bob@example.com', password: 'password')
    expect(account.roles.find(admin_role)).to be
  end

  it "has no accounts as admins initially" do
    expect(described_class::AUTOMATICALLY_ADMINS).to be_empty
  end
end
