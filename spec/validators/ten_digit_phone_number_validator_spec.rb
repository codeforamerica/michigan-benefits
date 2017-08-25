require "rails_helper"

describe TenDigitPhoneNumberValidator do
  let!(:member) { OpenStruct.new(errors: { phone_number: [] }) }
  subject { described_class.new(attributes: [:phone_number]) }

  specify do
    assert_invalid(nil)
  end

  specify do
    assert_invalid("123456789\n0")
  end

  specify do
    assert_valid("8177136264")
  end

  specify do
    assert_invalid("817713626")
  end

  specify do
    assert_invalid("81u7136264")
  end

  specify do
    assert_invalid("81471362634343434")
  end

  specify do
    assert_invalid("123456789\n0")
  end

  def assert_invalid(value)
    subject.validate_each(member, :phone_number, value)
    expect(member.errors[:phone_number]).to be_present
  end

  def assert_valid(value)
    subject.validate_each(member, :phone_number, value)
    expect(member.errors[:phone_number]).to eq []
  end
end
