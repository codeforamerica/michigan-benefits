class SectionGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("../templates", __FILE__)
  class_option :doc, type: :boolean, default: true, desc: "Include documentation."

  def generate_model
    generate_form_model
    generate_form_controller
    generate_form_view
    generate_form_model_spec
    generate_form_controller_spec

    puts "\nDone generating the #{model} section!"
    puts "Be sure to add Integrated::#{model}Controller in the desired application order in `form_navigation.rb`"
  end

  private

  alias_method :model, :name

  def generate_form_model
    template "form_model.template", "app/forms/#{model.underscore}_form.rb"
  end

  def generate_form_model_spec
    template "form_model_spec.template",
      "spec/forms/#{model.underscore}_form_spec.rb"
  end

  def generate_form_controller
    template "form_controller.template",
      "app/controllers/integrated/#{model.underscore}_controller.rb"
  end

  def generate_form_controller_spec
    template "form_controller_spec.template",
      "spec/controllers/integrated/#{model.underscore}_controller_spec.rb"
  end

  def generate_form_view
    template "form_view.template",
      "app/views/integrated/#{model.underscore}/edit.html.erb"
  end
end
