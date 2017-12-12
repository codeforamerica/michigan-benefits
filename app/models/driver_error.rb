class DriverError < ApplicationRecord
  belongs_to :driver_application
  has_one :snap_application, through: :driver_application

  validates :driver_application, presence: true
  validates :error_class, presence: true
  validates :error_message, presence: true
  validates :page_class, presence: true
  validates :page_html, presence: true

  def page_history
    driver_application.page_history.join("<br>").html_safe
  end
end
