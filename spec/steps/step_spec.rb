require "rails_helper"

describe Step do
  describe ".find" do
    specify { expect(Step.find("introduce-yourself", App.new)).to be_an_instance_of IntroduceYourself }
  end

  describe "#to_param" do
    specify { expect(IntroduceYourself.to_param).to eq "introduce-yourself" }
    specify { expect(IntroduceYourself.new(App.new).to_param).to eq "introduce-yourself" }
  end
end
