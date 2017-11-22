class MemberDecorator
  def initialize(member)
    @member = member
  end

  delegate :birthday, to: :member

  def formatted_birthday
    if birthday.present?
      birthday.strftime("%m/%d/%Y")
    else
      ""
    end
  end

  private

  attr_reader :member
end
