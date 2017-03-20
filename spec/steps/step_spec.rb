require "rails_helper"

describe Step do
  class TestStep < Step
    self.questions = [FirstName, LastName]
  end

  describe ".find" do
    specify { expect(Step.find("test-step", App.new)).to be_an_instance_of TestStep }
  end

  describe "#to_param" do
    specify { expect(TestStep.to_param).to eq "test-step" }
    specify { expect(TestStep.new(App.new).to_param).to eq "test-step" }
  end

  describe "#update" do
    let(:app) { App.new }
    let(:step) { TestStep.new(app) }

    context "when everything is valid" do
      it "updates the app" do
        step.update({ first_name: "Alice", last_name: "Aardvark" })
        expect(step).to be_valid
        expect(app.reload.first_name).to eq "Alice"
        expect(app.reload.last_name).to eq "Aardvark"
      end
    end

    context "when some fields are invalid" do
      it "does not update the app" do
        app.update! first_name: "Alice", last_name: "Aardvark"

        step.update({ first_name: "Billy", last_name: nil })
        expect(step).not_to be_valid
        expect(app.reload.first_name).to eq "Alice"
        expect(app.reload.last_name).to eq "Aardvark"
      end
    end
  end
end
