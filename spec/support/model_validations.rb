module ModelValidations
  def expect_valid_value(column, value)
    subject.send("#{column}=".to_sym, value)
    expect(subject).to be_valid
  end

  def expect_invalid_value(column, value)
    subject.send("#{column}=".to_sym, value)
    subject.valid?
    expect(subject.errors[column]).not_to be_empty
  end
end
