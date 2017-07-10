class Views::IntroductionIntroduceYourself::Edit < Views::Base
  needs :step

  def content
    content_for :header_title, 'Introduction'
    content_for :back_path, root_path

    if Rails.env.development?
      div class: "debug" do
        text StepNavigation.new(step).progress
        text " | "
        text step.class.name
        text " | app "
        text current_user.app.id
        text " | "
        link_to "Nav", steps_path
      end
    end

    div class: 'form-card' do
      form_for step, as: :step, url: introduction_introduce_yourself_path do |f|
        # TODO: Reconcile this with section_header in app/views/steps/helpers.rb
        header class: 'form-card__header' do
          div class: 'step-section-header' do
            div class: [
              "step-section-header__icon",
              "illustration",
              "illustration--hello"
            ]

            headline("We're here to help.")
            h3 "To start, please introduce yourself.", class: "step-section-header__subhead"
          end
        end

        div class: 'form-card__content' do
          question f, :first_name, 'What is your first name?' do
            text_field f, :first_name, 'First name'
          end

          question f, :last_name, 'What is your last name?' do
            text_field f, :last_name, 'Last name'
          end
        end

        footer class: 'form-card__footer' do
          button type: 'submit', class: "button button--cta button--full-width" do
            text 'Continue'
            i class: "button__icon icon-arrow_forward"
          end
        end
      end
    end
  end
end
