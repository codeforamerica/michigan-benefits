# frozen_string_literal: true

class Views::Widgets::BasicFormFor < Views::Base
  needs :form_for_params, :title, :definition, :submit

  def content
    row do
      column medium: 6 do
        h2 title if title

        form_for(*form_for_params) do |f|
          definition&.call(self)

          fields.each.with_index do |form_field, index|
            errors = f.object.present? ? f.object.errors[form_field.name] : nil

            f.label(form_field.name) do
              text form_field.title
              span(' &mdash; required'.html_safe, class: 'required') if form_field.required
              span errors.to_sentence, class: 'error-message' if errors.present?

              if form_field.type.to_sym == :text_area
                text f.text_area(form_field.name, autofocus: index == 0)
              elsif form_field.type.to_sym == :attachment
                text f.attachment_field(form_field.name)
              else
                text f.send("#{form_field.type}_field".to_sym, form_field.name, autofocus: index == 0)
              end
            end
          end

          f.submit (submit || 'Continue'), class: 'button special'
        end
      end
    end
  end

  def field(name, type: :text, title: name.to_s.humanize, required: false)
    fields << OpenStruct.new(type: type, name: name, title: title, required: required)
  end

  private

  def fields
    @fields ||= []
  end
end
