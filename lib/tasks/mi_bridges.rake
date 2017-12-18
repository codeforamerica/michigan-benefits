namespace :mi_bridges do
  desc "Run feature spec that tests the driving code"
  task run: :environment do
    puts "*" * 100
    puts "Running the MIBridges spec...this may take a few minutes."
    puts "*" * 100
    ENV["RUN_MI_BRIDGES_TEST"] = "true"
    sh "rspec spec/features/mi_bridges_driving_spec.rb"
  end
end
