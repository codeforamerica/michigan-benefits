# frozen_string_literal: true

class Views::Resources::Show < Views::Base
  def content
    content_for :template_name, 'step'
    content_for :header_title, 'Other Resources'
    content_for :back_path, confirmations_path

    div class: 'form-card', style: 'padding-top: 4em' do
      div class: 'slab step-section-header slab--white' do
        h3 class: 'step-section-header__subhead' do
          text 'Other resources near you'
        end

        help_text <<~TEXT
          While you are completing the enrollment process, you may consider
          contacting one of the many organizations in your community that offer
          additional assistance.
        TEXT
      end

      slab_with_card do
        list 'Food' do
          list_item 'Gleaners',
            '2131 Beaufait St',
            'Detroit, MI 48207',
            '313-923-3535',
            'www.gcfb.org',
            <<~TEXT
              A community food bank providing food to southeast Michigan
              residents. They also teach nutritional education programs, provide
              meals for kids after school and in the summer, operate mobile
              pantries and operate 3 free community gardens.
            TEXT

          list_item 'The Capuchin Soup Kitchen',
            '4390 Conner',
            'Detroit, MI 48215',
            '313-822-8606 x217',
            'www.cskdetroit.org',
            <<~TEXT
              They provide food to Detroit residents through their two soup
              kitchens and emergency food pantry. Additionally they offer
              clothing and run a treatment facility for drug and alcohol
              addictions.
            TEXT
        end
      end

      slab_with_card do
        list 'Health' do
          list_item 'Community Health and Social Services (CHASS)',
            '5635 West Fort Street',
            'Detroit, MI 48209',
            '313-849-3920',
            'chasscenter.org',
            <<~TEXT
              CHASS provides comprehensive and affordable primary health care
              and support services to Detroit residents.
            TEXT

          list_item 'Cass Community Social Services',
            '11850 Woodrow Wilson St',
            'Detroit, MI 48206',
            '313-883-2277',
            'casscommunity.org',
            <<~TEXT
              Cass Community Social Services provides health services, food,
              housing and job programs to Detroit residents.
            TEXT
        end
      end

      slab_with_card do
        list 'Employment' do
          list_item 'Focus Hope',
            '1355 Oakman Boulevard',
            'Detroit, Michigan 48238',
            '313-494-5500',
            'www.focushope.edu',
            <<~TEXT
              Focus Hope serves residents in southeast Michigan by providing
              workforce development trainings and education and addressing
              food and basic needs.
            TEXT

          list_item 'SER Metro',
            '9301 Michigan Avenue',
            'Detroit, MI 48210',
            '313-846-2240',
            'sermetro.org',
            <<~TEXT
              SER Metro provides training and job placement services for
              Metro-Detroit residents.
            TEXT
        end
      end
    end

    render partial: 'shared/footer'
  end

  def list(title)
    h4 title, class: 'step-section-header__headline'
    ul class: 'list--bulleted list--padded' do
      yield
    end
  end

  def list_item(name, addr1, addr2, phone, url, body)
    li do
      b name
      div body
      div addr1, class: 'text--help'
      div addr2, class: 'text--help'
      div do
        link_to "Call #{phone}", "tel:#{phone.remove(/[^\d]/)}", class: 'text--small'
      end
      div do
        link_to url, "http://#{url}", class: 'text--small'
      end
    end
  end
end
