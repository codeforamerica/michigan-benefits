class Views::Steps::HouseholdSituations < Views::Base
  needs :app, :step, :f

  def content

    unless app.everyone_a_citizen
      household_question f,
        :is_citizen,
        "Who is a citizen?",
        app.household_members
    end

    if app.anyone_disabled
      household_question f,
        :is_disabled,
        "Who has a disability?",
        app.household_members
    end

    if app.any_new_moms
      household_question f,
        :is_new_mom,
        "Who is pregnant or has been pregnant recently?",
        app.household_members
    end

    if app.anyone_in_college
      household_question f,
        :in_college,
        "Who is enrolled in college?",
        app.household_members
    end

    if app.anyone_living_elsewhere
      household_question f,
        :is_living_elsewhere,
        "Who is temporarily living outside the home?",
        app.household_members
    end
  end
end
