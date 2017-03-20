require "rails_helper"

describe Step do
  class TestQuestionA < Question
    self.model_attribute = :first_name
  end

  class TestQuestionB < Question
    self.model_attribute = :last_name
  end

  class TestStep < Step
    self.questions = [TestQuestionA, TestQuestionB]
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
        step.update({ test_question_a: "Alice", test_question_b: "Aardvark" })
        expect(step).to be_valid
        expect(app.reload.first_name).to eq "Alice"
        expect(app.reload.last_name).to eq "Aardvark"
      end
    end

    context "when some fields are invalid" do

    end
  end
end
