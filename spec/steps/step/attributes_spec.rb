require "rails_helper"

RSpec.describe Step do
  describe "#hash_key?" do
    it "returns true if the attribute is a hash key" do
      names = [
        { foo: [] },
        :bar,
      ]
      attrs = Step::Attributes.new(names)

      expect(attrs.hash_key?(:foo)).to eq true
    end

    it "returns false if the attribute is a symbol" do
      names = [
        { foo: [] },
        :bar,
      ]
      attrs = Step::Attributes.new(names)

      expect(attrs.hash_key?(:bar)).to eq false
    end
  end
end
