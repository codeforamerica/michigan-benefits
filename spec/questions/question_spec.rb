require "rails_helper"

describe Question do
  class TestQuestion < Question
    self.title = "What is your first name?"
    self.placeholder = "(First Name)"
    self.model_attribute = :first_name
  end

  let(:app) { App.new }
  let(:question) { TestQuestion.new(app) }

  describe "#name" do
    it "is a symbol derived from the class name" do
      expect(question.name).to eq :test_question
    end
  end

  describe "#get" do
    it "uses the model attribute" do
      expect {
        app.first_name = "Alice"
      }.to change { question.get }.from(nil).to("Alice")
    end
  end

  describe "#set" do
    it "sets the attribute on the model" do
      app.first_name = "Alice"
      expect {
        question.value = "Billy"
        question.set
      }.to change { app.first_name }.from("Alice").to("Billy")
    end

    context "when the type is :yes_no" do
      before do
        question.model_attribute = :accepts_text_messages
        question.type = :yes_no
      end

      it "converts to boolean" do
        question.value = "yes"
        question.set
        expect(app.accepts_text_messages).to eq true
      end

      it "handles nil" do
        question.value = nil
        question.set
        expect(app.accepts_text_messages).to eq nil
      end
    end
  end
end
