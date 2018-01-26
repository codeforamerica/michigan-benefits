RSpec.shared_examples "pdf component" do
  describe "#fill?" do
    it "should return a Boolean" do
      expect(subject.fill?).to be(true).or be(false)
    end
  end

  describe "#output_file" do
    it "should respond with no arguments" do
      expect(subject).to respond_to(:output_file).with(0).arguments
    end
  end
end
