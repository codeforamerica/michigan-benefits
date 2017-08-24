RSpec.shared_examples "social security number" do
  describe "social security number" do
    it "allows nils" do
      subject.ssn = nil
      expect(subject).to be_valid
    end

    it "allows ssns with no delimiters" do
      subject.ssn = "123121234"
      expect(subject).to be_valid
    end

    it "disallows bogus ssns" do
      subject.ssn = "BOGUS"
      expect(subject).not_to be_valid
    end

    it "invalidates bad SSNs with a friendly message" do
      subject.ssn = "111 22 333"
      expect(subject).not_to be_valid
      expect(subject.errors[:ssn]).to include(
        "Make sure your SSN has 9 digits",
      )
    end

    it "disallows bogus ssns with newlines" do
      subject.ssn = "BOGUS\n'--DROP TABLE CALFRESH_APPLICATIONS"
      expect(subject).not_to be_valid
    end

    it "does not allow dashes" do
      subject.ssn = "  123-12-1234  "
      expect(subject).to be_invalid
      expect(subject.errors[:ssn]).to include(
        "Make sure your SSN has 9 digits",
      )
    end
  end
end
