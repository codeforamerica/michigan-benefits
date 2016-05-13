class Views::Widgets::BasicFormFor < Views::Base
  needs :form_for_params, :title, :definition

  def content
    definition.call(self)

    row "align-center" do
      column medium: 6 do
        h2 title

        form_for *form_for_params do |f|
          fields.each.with_index do |form_field, index|
            errors = f.object.present? ? f.object.errors[form_field.name] : nil
            f.label(form_field.name) do
              text form_field.title
              span errors.to_sentence, class: "error-message" if errors.present?
              text f.send("#{form_field.type}_field".to_sym, form_field.name, autofocus: index == 0)
            end
          end

          f.submit "Continue", class: "button"
        end
      end
    end
  end

  def field(name, type: :text, title: name.to_s.humanize)
    fields << OpenStruct.new(type: type, name: name, title: title)
  end

  private

  def fields
    @fields ||= []
  end
end
