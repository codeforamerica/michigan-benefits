# frozen_string_literal: true

module MiBridges
  class Driver
    class MoreAboutRealPropertyPage < ClickNextPage
      TITLE = /More About (.*)'s Other Real Property/
    end
  end
end
