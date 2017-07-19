# frozen_string_literal: true

class Views::Users::New < Views::Base
  needs :user

  def content
    content_for :template_name, 'homepage'

    div class: "slab slab--hero slab--hero-#{rand(1..3)}" do
      div class: 'illustration--michigan-gov'
      h1 'Get the support your family needs'
      p 'Apply for Michigan Assistance Programs in 15 minutes'

      link_to '#fold', id: 'fold' do
        i class: 'icon-below-the-fold'
      end
    end

    apply_form
    already_started

    div class: 'slab slab--mdhhs' do
      h1 do
        div class: 'illustration--mdhhs'
      end

      p <<~TEXT, class: 'text--light'
        The Michigan Department of Health and Human Services offers temporary
        assistance programs that support families when times are tough.
      TEXT
    end

    render partial: 'shared/footer'
  end

  def already_started
    div class: 'slab already-started' do
      div class: 'card--narrow' do
        h3 class: 'h3--strong' do
          text 'Already started your application?'
        end

        current_upload_path = current_user ? documents_path : '#'

        link_to current_upload_path, class: 'button upload' do
          text 'Submit verification documents'
        end

        p 'Upload photos of documents requested by MDHHS staff',
          class: 'text--help text--padded'

        link_to '#', class: 'button contact' do
          text 'Contact your local office'
        end

        p 'For missed interview and other issues',
          class: 'text--help text--padded'

        current_resume_path = current_user ?
          step_path(StepNavigation.first) :
          '#'

        link_to current_resume_path, class: 'button resume' do
          text 'Resume your application'
          i class: 'button__icon icon-arrow_forward'
        end

        p 'If you need to finish an application you started previously',
          class: 'text--help text--padded'
      end
    end
  end

  def apply_form
    div id: 'apply-for-programs', class: 'slab slab--white' do
      div class: 'card--narrow' do
        h3 'Choose the programs you want to apply for today.',
          class: 'h3--strong'

        p 'You can choose more than one',
          class: 'text--help text--padded'

        form_for user do |_f|
          program_selector icon: 'health',
                           checked: true,
                           title: 'Healthcare Coverage',
                           subtitle: 'Medicaid, CHIP, and marketplace health insurance',
                           description: 'Free or low-cost health coverage that helps pay for '\
            'medical bills, doctors visits and prescriptions.'

          program_selector icon: 'food',
                           checked: true,
                           title: 'Food Assistance',
                           subtitle: 'Food Stamps, FAP or SNAP',
                           description: 'Provides benefits to buy or grow food.'

          program_selector icon: 'cash',
                           title: 'Cash Assistance',
                           subtitle: 'FIP, RCA, and SDA',
                           description: 'Temporary cash assistance for eligible pregnant '\
            'women, low-income families with young children, refugees, '\
            'and adults with disabilities.'

          program_selector icon: 'childcare',
                           title: 'Child Development + Care',
                           subtitle: 'CDC',
                           description: 'Helps pay for childcare.'

          program_selector icon: 'ser',
                           title: 'State Emergency Relief',
                           subtitle: 'SER',
                           description: 'Provides help or assistance for emergency situations.'

          button type: 'submit', class: 'button button--cta button--full-width' do
            text 'Apply now'
            i class: 'button__icon icon-arrow_forward'
          end
        end
      end
    end
  end

  def program_selector(**options)
    options = {
      checked: false,
      **options
    }

    label class: 'program-selector' do
      div class: 'program-selector__checkbox' do
        input type: 'checkbox',
              name: "apply-#{options[:icon]}",
              class: 'program-selector__checkbox-input',
              checked: options[:checked]
      end

      div class: 'program-selector__icon illustration '\
        "illustration--icn_#{options[:icon]}"

      h4 options[:title], class: 'program-selector__title'
      div options[:subtitle], class: 'program-selector__subtitle text--small'
      div options[:description], class: 'text--help'
    end
  end
end
