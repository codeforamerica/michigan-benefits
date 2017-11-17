require "rails_helper"

RSpec.describe Medicaid::IntroCaretakerMemberController do
  include_examples "application required"

  it "is the intro citizen path" do
    expect(subject.next_path).to eq(
      "/steps/medicaid/health-introduction",
    )
  end

  it_should_behave_like(
    "Medicaid multi-member controller",
    :anyone_caretaker_or_parent,
  )
end
