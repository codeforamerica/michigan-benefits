class Views::Users::New < Views::Base
  needs :user

  def content
    content_for :template_name, "homepage"

    div class: "slab slab--hero slab--hero-#{%w[dylan janice].sample}" do
      div class: "illustration--michigan-gov"
      h1 "Get the support your family needs"
      p "Apply for Michigan Assistance Programs in 15 min"

      div do
        link_to "Start Now",
          "#apply-for-programs",
          class: "button button--cta button--block"
      end

      if current_user
        link_to "Resume an application", step_path(Step.first.to_param), style: "color: white; text-decoration: underline"
      end
    end

    div class: "slab slab--mdhhs" do
      h1 do
        div class: "illustration--mdhhs"
      end

      p <<~TEXT
        The Michigan Department of Health and Human Services offers temporary assistance programs that
        support families when times are tough.
      TEXT
    end

    apply_form
    render partial: "shared/footer"
  end

  def apply_form
    div id: 'apply-for-programs', class: "slab slab--white" do
      div class: "card--narrow" do
        h2 "Choose the programs you want to apply for today."
        p "You can choose more than one", class: "text--help"

        form_for user do |f|
          program_selector \
          icon: "health",
            checked: true,
            title: "Healthcare Coverage",
            subtitle: "Medicaid, CHIP, and marketplace health insurance",
            description: "Free or low-cost health coverage that helps pay for "\
            "medical bills, doctors visits and prescriptions."

          program_selector \
          icon: "food",
            checked: true,
            title: "Food Assistance",
            subtitle: "Food Stamps, FAP or SNAP",
            description: "Provides benefits to buy or grow food."

          program_selector \
          icon: "cash",
            title: "Cash Assistance",
            subtitle: "FIP, RCA, and SDA",
            description: "Temporary cash assistance for eligible pregnant "\
            "women, low-income families with young children, refugees, "\
            "and adults with disabilities."

          program_selector \
          icon: "childcare",
            title: "Child Development + Care",
            subtitle: "CDC",
            description: "Helps pay for childcare."

          program_selector \
          icon: "ser",
            title: "State Emergency Relief",
            subtitle: "SER",
            description: "Provides help or assistance for emergency situations."

          button type: 'submit', class: "button button--cta button--full-width" do
            text "Apply now"
            i class: "button__icon icon-arrow_forward"
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

      div class: "illustration illustration--icn_#{options[:icon]}"

      h4 options[:title]
      p options[:subtitle]
      p options[:description], class: "text--help"
    end
  end
end
