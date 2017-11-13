class MedicaidApplicationMemberAttributes
  def initialize(member:, position:)
    @member = member
    @position = position
  end

  def to_h
    {
      "#{position}_member_full_name" => member.display_name,
    }.symbolize_keys
  end

  private

  attr_reader :member, :position
end
