class MemberMeta < Step
  self.title = "Your Household"
  self.subhead = "Ok, let us know which people these situations apply to."

  self.questions = {
    in_college: "Who is enrolled in college?",
    is_disabled: "Who has a disability?"
  }

  self.types = {
    in_college: :checkbox,
    is_disabled: :checkbox
  }

  attr_accessor \
    :household_members,
    :in_college,
    :is_disabled


  def previous
    HouseholdMeta.new(@app)
  end

  def next
    IncomeIntroduction.new(@app)
  end

  def member_attributes
    # {"step"=>
    #   {"household_members"=>
    #     {
    #     "1"=>{"in_college"=>"0", "is_disabled"=>"1"},
    #     "2"=>{"in_college"=>"0", "is_disabled"=>"0"}
    #     "3"=>{"in_college"=>"0", "is_disabled"=>"1"}}}, "id"=>"member-meta"}
  end

  def assign_from_app
    # member_attributes.each do |k,v|
    #   member = @app.household_members.find_by(id: k)
    #   assign_attributes member.attributes.slice *%w[
    #     in_college
    #     is_disabled
    #   ]
    # end
  end

  def update_app!
    # member_attributes.each do |k,v|
    #   member = @app.household_members.find_by(id: k)
    #   member.update_attributes(
    #     in_college: in_college,
    #     is_disabled: is_disabled
    #   )
    # end
    # @app.update!
  end
end
