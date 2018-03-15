module BirthdayValidations
  def birthday_present?
    %i[birthday_year birthday_month birthday_day].all? { |att| send(att).present? }
  end

  def birthday_must_be_present
    unless birthday_present?
      errors.add(:birthday, I18n.t(:full_birthday))
    end
  end

  def birthday_must_be_valid_date
    if birthday_present? && !errors.added?(:birthday, I18n.t(:full_birthday))
      begin
        DateTime.new(birthday_year.to_i, birthday_month.to_i, birthday_day.to_i)
      rescue ArgumentError
        errors.add(:birthday, I18n.t(:real_birthday))
      end
    end
  end
end
