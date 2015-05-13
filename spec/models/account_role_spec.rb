require 'rails_helper'

describe AccountRole do
  context 'invalid' do
    let(:account) { create :account }
    let(:role) { create :role }
    subject(:account_role) { create :account_role, account, role }

    specify { expect_invalid_value(:account, nil) }
    specify { expect_invalid_value(:role, nil) }
  end
end
