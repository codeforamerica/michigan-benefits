module TypeCheckbox
  extend ActiveSupport::Concern

  def edit
    super

    assign_checkbox_values
  end

  def update_models
    new_types = checkbox_options.select{ |key| form_params[key] == "1" }
    new_types.each do |type|
      checkbox_collection.find_or_create_by(checkbox_attribute => type)
    end

    checkbox_collection.where.not(checkbox_attribute => new_types).destroy_all
  end

  private

  def assign_checkbox_values
    checkbox_options.each do |name|
      @form.assign_attribute(name, false)
    end
    checkbox_collection.each do |expense|
      @form.assign_attribute(expense.public_send(checkbox_attribute), true)
    end
  end

end
