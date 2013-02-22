#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

CalendarSigabrtOrg::Application.load_tasks

desc "Remove old paper_trail Version"
task :clean => :environment do
  Version.destroy_all(["created_at < ?", 1.week.ago])
end
