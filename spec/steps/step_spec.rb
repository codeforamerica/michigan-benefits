require "rails_helper"

RSpec.describe Step, type: :model do
  describe ".step_attributes" do
    it "creates setters and getters" do
      class TestStep < Step
        step_attributes(:foo, :bar)
      end

      expected_methods = %i[foo foo= bar bar=]

      expect(TestStep.new.methods).to include(*expected_methods)
    end

    it "allows hashes with collections for attributes" do
      class TestStep < Step
        step_attributes(
          {
            foo: [],
            bar: [],
          },
          :baz,
        )
      end

      expected_methods = %i[foo foo= bar bar= baz baz=]

      expect(TestStep.new.methods).to include(*expected_methods)
    end

    it "exposes attribute names on the class" do
      class TestStep < Step
        step_attributes(:foo, :bar)
      end

      expect(TestStep.attribute_names).to match_array(%i[foo bar])
    end
  end
end
