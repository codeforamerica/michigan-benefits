require 'rails_helper'

describe Account do
  subject(:account) { create :account }
  let(:role1) { create :role, name: 'Fun 1' }
  let(:role2) { create :role, name: 'Fun 2' }

  it 'can have roles' do
    account.roles = [role1, role2]
  end
end
