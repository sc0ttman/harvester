class HarvestSyncJob < ApplicationJob
  queue_as :default

  def perform(model_name = :all)
    unless model_name.to_sym == :all
      SyncService.new.sync_data(model_name.to_sym)
    else
      SyncService.new.sync_data(:project)
      SyncService.new.sync_data(:user)
      SyncService.new.sync_data(:task)
      SyncService.new.sync_data(:entry)
    end
  end
end
