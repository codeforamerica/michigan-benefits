require 'rails_helper'

describe AccountRole do
  context 'invalid' do
    let(:account) { create :account }
    let(:role) { create :role }
    subject(:account_role) { create :account_role, account, role }

    it 'requires account' do
      account_role.account = nil
      expect(account_role).not_to be_valid
      expect(account_role.errors[:account]).not_to be_empty
    end

    it 'requires role' do
      account_role.role = nil
      expect(account_role).not_to be_valid
      expect(account_role.errors[:role]).not_to be_empty
    end
  end
end
