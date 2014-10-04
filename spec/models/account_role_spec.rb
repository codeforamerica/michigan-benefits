require 'rails_helper'

describe AccountRole do
  context 'invalid' do
    subject(:account_role) { AccountRole.new }

    before { is_expected.not_to be_valid }

    it 'requires account' do
      expect(account_role.errors[:account]).not_to be_empty
    end

    it 'requires role' do
      expect(account_role.errors[:role]).not_to be_empty
    end
  end
end
