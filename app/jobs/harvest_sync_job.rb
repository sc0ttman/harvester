class HarvestSyncJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    SyncService.new.sync_data(:project)
    SyncService.new.sync_data(:user)
    SyncService.new.sync_data(:task)
    SyncService.new.sync_data(:entry)
  end
end
