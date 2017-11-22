class MemberDecorator
  def initialize(member)
    @member = member
  end

  delegate :birthday, to: :member

  def formatted_birthday
    birthday.present? ? birthday.strftime("%m/%d/%Y") : ""
  end

  private

  attr_reader :member
end
