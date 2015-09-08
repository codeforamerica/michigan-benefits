require 'rails_helper'

describe Account do
  subject(:account) { create :account }
  let(:role1) { create :role, name: 'Fun 1' }
  let(:role2) { create :role, name: 'Fun 2' }

  it 'can have roles' do
    account.roles = [role1, role2]
  end

  it 'enforces unique emails, case-insensitively' do
    alice1 = create :account, email: 'alice@example.com'
    expect { create :account, email: 'Alice@example.com' }.to raise_error(ActiveRecord::RecordInvalid)
  end

  # this is kind of unfortunate --
  # would be better with a "email-as-entered" field and
  # a separate lowercase "email-as-authenticated-username" field
  it 'makes emails all lowercase' do
    alice = create :account, email: 'ALICE@example.com'
    expect(alice.email).to eq('alice@example.com')
  end

  it 'requires password to be 8 characters' do
    account = Account.new(email:"foo@bar.com", password:"1234567")
    account.password_required = true
    expect(account).to_not be_valid
    account.password = "12345678"
    expect(account).to be_valid
  end
end
