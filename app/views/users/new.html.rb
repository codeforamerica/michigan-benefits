class Views::Users::New < Views::Base
  needs :user

  def content
    content_for :template_name, "homepage"

    div class: "slab slab--hero slab--hero-#{%w[dylan janice].sample}" do
      div class: "illustration--michigan-gov"
      h1 "Get the support your family needs"
      p "Apply for Michigan Assistance Programs in 15 min"

      form_for user do |f|
        f.submit "Start Now", class: "button button--cta"
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

    div class: "main-footer" do
      p <<~TEXT, class: "text--small"
        This site hosts a multi-benefit application and enrollment prototype, delivered by Code for 
        America and Civilla.
      TEXT

      p <<~TEXT, class: "text--small"
        This prototype has been designed to model how to create simpler, more user-centered 
        application experience in Michigan.
      TEXT

      p <<~TEXT, class: "text--small"
        This is a template that MDHHS can customize for its enrollment programs.
      TEXT

      div class: "illustration illustration--cfa"
      div class: "illustration illustration--civilla"
    end
  end
end
