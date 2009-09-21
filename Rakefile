# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

require 'websolr_rails/tasks'

desc "Load fixtures data into the development database"
task :load_fixtures_data_to_development do
   require 'active_record/fixtures'
   ActiveRecord::Base.establish_connection(
       ActiveRecord::Base.configurations["development"])
   Fixtures.create_fixtures("test/fixtures",
       ActiveRecord::Base.configurations[:fixtures_load_order])
end