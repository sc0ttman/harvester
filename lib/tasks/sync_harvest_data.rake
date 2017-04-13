require 'activerecord-import'

namespace :sync do
  desc "Launches a job that deletes all local data and re-syncs to Harvest"
  task :all => [:environment] do
    HarvestSyncJob.perform_later('all')
  end

  desc 'Delete and resync all entries from a x until now'
  task :entries => [:environment] do
    HarvestSyncJob.perform_later('entry')
  end

  desc 'Delete and resync all users'
  task :users => [:environment] do
    HarvestSyncJob.perform_later('user')
  end

  desc 'Delete and resync projects'
  task :projects => [:environment] do
    HarvestSyncJob.perform_later('project')
  end

  desc 'Delete and resync tasks'
  task :tasks => [:environment] do
    HarvestSyncJob.perform_later('task')
  end
end
