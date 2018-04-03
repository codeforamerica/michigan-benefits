require_relative "../section_generator"

module Section
  class WhoIsGenerator < Rails::Generators::NamedBase
    source_root File.expand_path("../templates", __FILE__)
    class_option :doc, type: :boolean, default: true, desc: "Include documentation."

    def generate_sections
      generate_section("AreYou")
      generate_section("Anyone")
      generate_section("WhoIs")
      add_enum_to_member

      puts "\nDone generating the #{model_name} section!"
      puts "Be sure to add Integrated::#{model_name}Controller in the desired application order in `form_navigation.rb`"
    end

    private

    def model_name
      name.camelcase
    end

    def model_method
      name.underscore
    end

    def generate_section(section_type)
      section_name = section_type + model_name

      generate_form_model(section_type, section_name)
      generate_form_model_spec(section_type, section_name) if section_name == "WhoIs"
      generate_form_controller(section_type, section_name)
      generate_form_controller_spec(section_type, section_name)
      generate_form_view(section_type, section_name)
    end

    def add_enum_to_member
      inject_into_file "app/models/household_member.rb",
        before: "  # Generated enums added above\n" do <<-EOT
  enum #{model_method}: { unfilled: 0, yes: 1, no: 2 }, _prefix: :#{model_method}
        EOT
      end
    end

    def generate_form_model(section_type, model_name)
      template "#{section_type.underscore}/form_model.template.rb",
        "app/forms/#{model_name.underscore}_form.rb"
    end

    def generate_form_model_spec(section_type, model_name)
      template "#{section_type.underscore}/form_model_spec.template.rb",
        "spec/forms/#{model_name.underscore}_form_spec.rb"
    end

    def generate_form_controller(section_type, model_name)
      template "#{section_type.underscore}/form_controller.template.rb",
        "app/controllers/integrated/#{model_name.underscore}_controller.rb"
    end

    def generate_form_controller_spec(section_type, model_name)
      template "#{section_type.underscore}/form_controller_spec.template.rb",
        "spec/controllers/integrated/#{model_name.underscore}_controller_spec.rb"
    end

    def generate_form_view(section_type, model_name)
      template "#{section_type.underscore}/form_view.template.erb",
        "app/views/integrated/#{model_name.underscore}/edit.html.erb"
    end
  end
end
