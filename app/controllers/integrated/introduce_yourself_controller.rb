module Integrated
  class IntroduceYourselfController < FormsController
    def update_models
      member_data = params_for(:member).merge(
        relationship: "primary",
        requesting_food: yes_or_no(:applying_for_food),
        requesting_healthcare: yes_or_no(:applying_for_healthcare),
        buy_and_prepare_food_together: yes_or_no(:applying_for_food),
      )
      member_data.merge!(combined_birthday_fields(
                           day: member_data.delete(:birthday_day),
                           month: member_data.delete(:birthday_month),
                           year: member_data.delete(:birthday_year),
                         ))
      if current_application.primary_member
        current_application.primary_member.update(member_data)
      else
        current_application.members.create(member_data)
      end
      current_application.update(params_for(:application))
    end

    private

    def existing_attributes
      if current_application.primary_member
        attributes = current_application.attributes.merge(current_application.primary_member.attributes)
        %i[year month day].each do |sym|
          attributes["birthday_#{sym}"] = current_application.primary_member.birthday.try(sym)
        end
        HashWithIndifferentAccess.new(attributes)
      else
        {}
      end
    end

    def yes_or_no(attribute)
      current_application.navigator.public_send(attribute) ? "yes" : "no"
    end
  end
end
