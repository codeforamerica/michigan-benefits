require 'rails_helper'

describe Role do
  context 'invalid' do
    subject(:role) { create :role }
    let(:existing_role) { create :role, name: 'Another Role' }

    specify { expect_invalid_value(:name, '') }
    specify { expect_invalid_value(:key, '') }
    specify { expect_invalid_value(:key, existing_role.key) }
  end

  context 'valid' do
    subject(:role) { create :role }
    let(:account1) { create :account, email: 'user1@example.com' }
    let(:account2) { create :account, email: 'user2@example.com' }

    it 'can have accounts' do
      role.accounts = [account1, account2]
    end
  end
end
