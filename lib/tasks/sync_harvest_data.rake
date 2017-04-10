# require 'SyncService'

namespace :sync do
  desc "Deletes all local cached data and re-syncs to Harvest"
  # TODO: options for organization and models. Do everything for now.
  task :all do
    Rake::Task['sync:projects'].invoke
    Rake::Task['sync:users'].invoke
    Rake::Task['sync:tasks'].invoke
    Rake::Task['sync:entries'].invoke
  end

  desc 'Delete and resync all entries from a x until now'
  task :entries => [:environment] do
    SyncService.new.sync_entries
  end

  desc 'Delete and resync all users'
  task :users => [:environment] do
    SyncService.new.sync_users
  end

  desc 'Delete and resync projects'
  task :projects => [:environment] do
    SyncService.new.sync_projects
  end

  desc 'Delete and resync tasks'
  task :tasks => [:environment] do
    SyncService.new.sync_tasks
  end
end
