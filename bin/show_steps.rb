# run with `rails runner ./bin/show_steps.rb`

puts

next_step = IntroductionIntroduceYourself.new(App.first)
i = 0

while next_step = next_step.next
  print "#{i += 1} - "
  print next_step.class.to_param
  puts " - #{next_step.subhead}"
end
