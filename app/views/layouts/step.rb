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
    div class: 'step-header' do
      h4 class: 'step-header__title' do
        text header_title
      end
    end
  end

  def header_title
    content_for :header_title
  end
end
