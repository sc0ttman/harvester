# For now this data should be set in your ENV vars.
# This is currently done for you automatically by Figaro if you have the application.yml file configured
ORGANIZATION_ENV_PREFIXES = %w(harvest_paradem harvest_partner)

class SyncService

  def initialize()
    @harvest_clients = []

    # Instantiate Harvest clients for each Org set in ENV
    ORGANIZATION_ENV_PREFIXES.each do |env_prefixes|
      @harvest_clients << HarvestService.new(
          subdomain: ENV["#{env_prefixes}_subdomain"],
          username: ENV["#{env_prefixes}_username"],
          password: ENV["#{env_prefixes}_password"],
          project_id: ENV["#{env_prefixes}_project_id"])
    end
  end


  def sync_entries
    Entry.delete_all
    @harvest_clients.each do |client|
      entries = client.get_project_entries()
      puts "getting entries for org: #{client.get_project} Entries count: #{entries.length}"
      entries.each{|e| valid_attrs = e.select{|x| Entry.attribute_names.index(x.to_s)}; ar=Entry.create(valid_attrs); puts "#{e.errors.full_messages.to_sentence}" if ar.errors.any? }
    end
  end

  def sync_users
    User.delete_all

    # TODO: We may have to signify organizaion our own way
    @harvest_clients.each do |client|
      users = client.get_users
      puts "Syncing users from Harvest. Users count: #{users.length}"
      users.each{|u| valid_attrs = u.select{|x| User.attribute_names.index(x.to_s)}; ar=User.create(valid_attrs); puts "#{e.errors.full_messages.to_sentence}" if ar.errors.any? }
    end
  end

  def sync_projects
    Project.delete_all

    @harvest_clients.each do |client|
      project = client.get_project
      valid_attrs = project.select{|x| Project.attribute_names.index(x.to_s)}
      Project.create(valid_attrs)
    end
  end

  def sync_tasks
    Task.delete_all

    @harvest_clients.each do |client|
      tasks = client.get_tasks
      tasks.each{|t| valid_attrs = t.select{|x| Task.attribute_names.index(x.to_s)}; ar=Task.create(valid_attrs); puts "#{e.errors.full_messages.to_sentence}" if ar.errors.any? }
    end
  end


end
