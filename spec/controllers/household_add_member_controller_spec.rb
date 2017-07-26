# frozen_string_literal: true

require "rails_helper"

RSpec.describe HouseholdAddMemberController, :member, type: :controller do
  let!(:current_app) do
    App.create!(user: member)
  end

  let(:member_attributes) do
    {
      first_name: "alice",
      last_name: "smith",
      sex: "male",
      relationship: "roommate",
      ssn: "123-45-6789",
      in_home: true,
      buy_food_with: true,
    }.with_indifferent_access
  end

  let(:step) do
    assigns(:step)
  end

  describe "#edit" do
    pending "assigns existing member attrs if there is an existing member" do
      member = current_app.household_members.create!(member_attributes)

      get :edit, params: { member_id: member.id }

      member_attributes.each do |key, value|
        expect(step.send(key)).to eq(value)
      end
    end

    pending "assigns nothing otherwise" do
      get :edit

      member_attributes.keys.each do |key|
        expect(step.send(key)).not_to be
      end
    end
  end

  describe "#update" do
    pending "creates a member" do
      expect do
        put :update, params: { step: member_attributes }
      end.to change {
        current_app.household_members.reload.count
      }.by(1)

      expect(
        current_app.household_members.last.attributes,
      ).to include(member_attributes)
    end
  end
end
