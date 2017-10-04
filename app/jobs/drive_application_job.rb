class DriveApplicationJob < ApplicationJob
  def perform(snap_application:)
    if snap_application.driver_applications.empty?
      MiBridges::Driver.new(snap_application: snap_application).run
    end
  end
end
