# frozen_string_literal: true

require "rails_helper"

RSpec.describe HouseholdAddMemberController do
  let(:step) { assigns(:step) }
  let(:invalid_params) { { step: { first_name: "", last_name: "" } } }
  let(:step_class) { HouseholdAddMember }

  before { session[:snap_application_id] = current_app.id }

  include_examples "step controller"

  describe "#edit" do
    context "existing member" do
      it "assigns the fields to the step" do
        get :edit, params: { member_id: member.id }

        expect(step.sex).to eq("male")
        expect(step.relationship).to eq("Child")
        expect(step.ssn).to eq("12345")
      end
    end
  end

  def current_app
    @_current_app ||= create(:snap_application, members: [member])
  end

  def member
    @_member ||=
      create(:member, sex: "male", relationship: "Child", ssn: "12345")
  end
end
