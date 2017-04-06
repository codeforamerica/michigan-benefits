class Views::Confirmations::Show < Views::Base
  def content
    content_for :template_name, "step"
    content_for :header_title, "Confirmation"

    div class: "form-card", style: "padding-top: 4em" do
      div class: "slab step-section-header slab--white" do

        div class: "step-section-header__icon illustration illustration--success"
        h4 "Congratulations", class: "step-section-header__headline"
        h3 class: "step-section-header__subhead" do
          text "Your application has been successfully submitted."
        end

        p "Submitted to MDHHS on #{Date.today}.", class: "text--help"

        div "You applied for", class: "h6"

        label class: 'program-selector program-selector__unbordered' do
          div class: "program-selector__icon illustration " \
            "illustration--icn_health"
          h4 "Healthcare Coverage", class: 'program-selector__title'
        end

        label class: 'program-selector program-selector__unbordered' do
          div class: "program-selector__icon illustration " \
            "illustration--icn_food"
          h4 "Food Assistance", class: 'program-selector__title'
        end
      end

      div class: "slab slab--not-padded" do
        div class: "card card--narrow" do
          h4 "What happens next?", class: "text--centered"

          div style: "text-align: center" do
            div style: "margin-top: 4rem" do
              icon "interview"
              h4 "Do an interview"
              div "to go over your situation", class: "text--help"
              div "In about 1 week", class: "h6"
            end

            div style: "margin-top: 4rem" do
              icon "submit-docs"
              h4 "Submit documents"
              div "to verify your eligibility", class: "text--help"
              div "Within 30 days", class: "h6"
            end
          end
        end
      end

      div class: "slab slab--not-padded" do
        div class: "card card--narrow" do
          h4 "What to expect:", class: "step-section-header__headline"

          ul class: "list--bulleted" do
            li do
              b "Your local office will call you in the next week for your phone interview."
              text " The call may come from a blocked number."
            end
            li do
              b "The interview will take about 30 minutes. "
              text "A worker will ask you about your household, income, expenses, and other eligibility requirements."
            end
            li do
              b "Your county will provide you with a list of documents "
              text "that you will need to submit within 30 days from today to verify your eligibility. You can submit documents any time at michigan.gov/docs"
            end
            li do
              b "We’ll occassionally follow up with you"
              text " by text message and email to help you through the rest of the 30-day process."
            end
          end
        end
      end

      div class: "slab" do
        link_to "Find community services nearby", resource_path, class: "button button--cta button--full-width text--centered"
      end
    end

    render partial: "shared/footer"
  end

  def icon(name)
    div class: "illustration illustration--compact illustration--#{name}"
  end
end
