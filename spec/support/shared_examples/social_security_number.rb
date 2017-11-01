RSpec.shared_examples "social security number" do
  describe "social security number" do
    it "allows nils" do
      subject.last_four_ssn = nil
      expect(subject).to be_valid
    end

    it "allows ssn to start with zero" do
      subject.last_four_ssn = "0123"
      expect(subject).to be_valid
    end

    it "allows ssns with no delimiters" do
      subject.last_four_ssn = "1231"
      expect(subject).to be_valid
    end

    it "disallows bogus ssns" do
      subject.last_four_ssn = "BOGUS"
      expect(subject).not_to be_valid
    end

    it "invalidates bad SSNs with a friendly message" do
      subject.last_four_ssn = "11 12"
      expect(subject).not_to be_valid
      expect(subject.errors[:last_four_ssn]).to include(
        "Make sure to provide the last 4 digits",
      )
    end

    it "disallows bogus ssns with newlines" do
      subject.last_four_ssn = "BOGUS\n'--DROP TABLE CALFRESH_APPLICATIONS"
      expect(subject).not_to be_valid
    end

    it "does not allow dashes" do
      subject.last_four_ssn = "  1-234  "
      expect(subject).to be_invalid
      expect(subject.errors[:last_four_ssn]).to include(
        "Make sure to provide the last 4 digits",
      )
    end
  end
end
