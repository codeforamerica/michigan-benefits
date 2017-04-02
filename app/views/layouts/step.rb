class Views::Layouts::Step < Views::Layouts::Application
  def content
    content_for :template_name, "step"

    super do
      menu_header

      yield

      render partial: "shared/footer"
    end
  end

  private

  def menu_header
    back_path = content_for :back_path

    div class: 'step-header' do
      if back_path
        link_to "#{back_path}?rel=back", class: 'step-header__back-link' do
          i class: "button__icon icon-arrow_back"
        end
      end

      h4 class: 'step-header__title' do
        text header_title
      end
    end
  end

  def header_title
    content_for :header_title
  end
end
