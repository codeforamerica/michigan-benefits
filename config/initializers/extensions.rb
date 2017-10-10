Dir["#{Rails.root}/lib/mi_bridges/*.rb"].each do |file|
  require file
end

Dir["#{Rails.root}/lib/mi_bridges/driver/services/*.rb"].each do |file|
  require file
end

Dir["#{Rails.root}/lib/mi_bridges/driver/*.rb"].each do |file|
  require file
end
