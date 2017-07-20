# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HouseholdMembersOverviewController, :member, type: :controller do
  let!(:current_app) do
    App.create(user: member)
  end

  let(:household_member) do
    HouseholdMember.create!(first_name: 'alice')
  end

  let(:step) do
    assigns(:step)
  end

  it 'assigns the fields to the step' do
    current_app.applicant.update!(first_name: 'bob')
    current_app.household_members << household_member

    get :edit

    expect(step.first_name).to eq('bob')
    expect(step.non_applicant_members.map(&:first_name)).to eq(['alice'])
  end
end
