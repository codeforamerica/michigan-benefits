FactoryGirl.define do
  factory :driver_error do
    driver_application

    error_class "RuntimeError"
    error_message "runtime error"
    page_class "MiBridges::Driver::BasePage"
    page_html "<html></html>"
  end
end
