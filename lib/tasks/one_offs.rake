# Place idempotent, one off execution things here so they get auto-ran on deploy
namespace :one_offs do
  desc "runs all one_offs, remove things from here after they are deployed"
  task run_all: :environment do
    Employment.where(hours_per_week: nil).where.not(hours_per_week_int: nil).find_each do |employment|
      puts "Updating: Employment ##{employment.id}..."
      employment.hours_per_week = employment.hours_per_week_int.to_s
      employment.save!
      puts "Completed: Employment ##{employment.id}"
    end
  end
end
