require 'schedule'

# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

every 1.day, at: '4:30 am' do
  runner "Persona.actualizar_email_nil"
end

every 1.day, at: '00:00 am' do
  User.all.each { |user| user.regenerate_reset_password_token! }
  Persona.all.each { |persona| persona.regenerate_confirmation_token! }
end