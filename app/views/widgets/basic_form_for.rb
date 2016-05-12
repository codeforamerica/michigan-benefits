class Views::Widgets::BasicFormFor < Views::Base
  needs :form_for_params, :title, :definition

  def content
    definition.call(self)

    row "align-center" do
      column medium: 6 do
        h2 title

        form_for *form_for_params do |f|
          fields.each do |x|
            f.label(x.name) do
              text x.title
              text f.send("#{x.type}_field".to_sym, x.name)
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
