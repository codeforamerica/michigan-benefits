require "rails_helper"

RSpec.describe Step do
  describe "#to_s" do
    it "returns strings of hash keys or symbols in attribute names" do
      names = [
        { foo: [] },
        :bar,
      ]
      attrs = Step::Attributes.new(names)

      expect(attrs.to_s).to eq %w[foo bar]
    end

    context "when passed attribute names is nil" do
      it "returns empty array" do
        attrs = Step::Attributes.new(nil)

        expect(attrs.to_s).to eq []
      end
    end
  end

  describe "#to_sym" do
    it "returns symbols of hash keys or symbols in attribute names" do
      names = [
        { foo: [] },
        :bar,
      ]
      attrs = Step::Attributes.new(names)

      expect(attrs.to_sym).to eq %i[foo bar]
    end

    context "when passed attribute names is nil" do
      it "returns empty array" do
        attrs = Step::Attributes.new(nil)

        expect(attrs.to_sym).to eq []
      end
    end
  end

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
