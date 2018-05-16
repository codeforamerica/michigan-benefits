require "rails_helper"

RSpec.describe Form do
  describe ".attributes_for" do
    it "defaults to an empty array" do
      class TestFormOne < Form; end
      expect(TestFormOne.attributes_for(:application)).to eq([])
    end

    it "creates a getter that returns passed in attributes as keys" do
      class TestFormTwo < Form; end
      TestFormTwo.set_attributes_for :application, :foo, bar: []

      expect(TestFormTwo.attributes_for(:application)).to match_array([
                                                                        :foo,
                                                                        { bar: [] },
                                                                      ])
    end
  end

  describe ".attribute_names" do
    it "returns what is set by application and member attributes" do
      class TestFormFour < Form; end

      TestFormFour.set_attributes_for :application, :foo
      TestFormFour.set_attributes_for :member, :bar
      TestFormFour.set_attributes_for :navigator, :baz

      expect(TestFormFour.attribute_names).to match_array(%i[foo bar baz])
      expect { TestFormFour.new.foo }.not_to raise_error
      expect { TestFormFour.new.bar }.not_to raise_error
      expect { TestFormFour.new.baz }.not_to raise_error
    end
  end
end
