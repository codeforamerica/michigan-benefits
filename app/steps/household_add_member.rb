class HouseholdAddMember < Step
  self.title = "Your Household"
  self.subhead = "Tell us about another person you are applying with."
  self.subhead_help = "If you don't know the answer to a question, that's okay."

  self.questions = {
    first_name: "What is their first name?",
    last_name: "What is their last name?",
    sex: "What is their sex?",
    relationship: "What is their relationship to you?",
    ssn: "What is their social security number?",
    in_home: "Is this person living in your home?",
    buy_food_with: "Do you buy and prepare food with this person?"
  }

  self.types = {
    sex: :radios,
    relationship: :select,
    in_home: :yes_no,
    buy_food_with: :yes_no
  }

  self.field_options = {
    sex: %w|male female|,
    relationship: %w|Spouse Parent Child Sibling Roommate|
  }

  self.help_messages = {
    sex: "As it appears on their birth certificate",
    ssn: "If they don’t have one or you don’t know it you can skip this",
    buy_food_with: <<~HTML.html_safe
      <span class='label label--food-assistance'>Food Assistance</span>
    HTML
  }

  self.safeties = {
    ssn: <<~TEXT
      Social security numbers help ensure you receive the correct benefits. 
      MDHSS maintains strict security guidelines to protect the identities of 
      our residents.
    TEXT
  }

  attr_accessor \
    :first_name,
    :last_name,
    :sex,
    :relationship,
    :ssn,
    :in_home,
    :buy_food_with

  def member
    if member_id
      @app.household_members.find_by(id: member_id)
    else
      @app.household_members.build
    end
  end

  def member_id
    @params["member_id"]
  end

  def assign_from_app
    assign_attributes member.attributes.slice *%w[
      first_name
      last_name
      sex
      relationship
      ssn
      in_home
      buy_food_with
    ]
  end

  def update_app!
    member.update!(
      first_name: first_name,
      last_name: last_name,
      sex: sex,
      relationship: relationship,
      ssn: ssn,
      in_home: in_home,
      buy_food_with: buy_food_with,
    )
  end
end
