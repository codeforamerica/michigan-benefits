require "rails_helper"

RSpec.describe Form do
  describe ".application_attributes" do
    it "defaults to an empty array" do
      class TestFormOne < Form; end
      expect(TestFormOne.application_attributes).to eq([])
    end

    it "creates a getter that returns passed in attributes as keys" do
      Form.set_application_attributes(:foo, bar: [])

      expect(Form.application_attributes).to match_array([
        :foo,
        {:bar=>[]},
      ])
    end
  end

  describe ".member_attributes" do
    it "defaults to an empty array" do
      class TestFormTwo < Form; end

      expect(TestFormTwo.member_attributes).to eq([])
    end

    it "creates a getter that returns passed in attributes as keys" do
      Form.set_member_attributes(:foo, bar: [])

      expect(Form.member_attributes).to match_array([
        :foo,
        {:bar=>[]},
      ])
    end
  end

  describe ".navigator_attributes" do
    it "defaults to an empty array" do
      class TestFormThree < Form; end
      expect(TestFormThree.navigator_attributes).to eq([])
    end

    it "creates a getter that returns passed in attributes as keys" do
      Form.set_navigator_attributes(:foo, bar: [])

      expect(Form.navigator_attributes).to match_array([
        :foo,
        {:bar=>[]},
      ])
    end
  end

  describe ".attribute_names" do
    it "returns what is set by application and member attributes" do
      class TestFormFour < Form; end

      TestFormFour.set_application_attributes(:foo)
      TestFormFour.set_member_attributes(:bar)
      TestFormFour.set_navigator_attributes(:baz)

      expect(TestFormFour.attribute_names).to match_array(%i[foo bar baz])
      expect { TestFormFour.new.foo }.not_to raise_error
      expect { TestFormFour.new.bar }.not_to raise_error
      expect { TestFormFour.new.baz }.not_to raise_error
    end
  end
end
