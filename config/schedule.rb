set :output, "log/cron.log"

every 1.minute do
  puts "Test"
  # command "ruby main.rb"
  # runner "MyModel.some_method"
  # rake "some:great:rake:task"
end
