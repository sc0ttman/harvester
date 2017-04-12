# For now this data should be set in your ENV vars.
# This is currently done for you automatically by Figaro if you have the application.yml file configured
ORGANIZATION_ENV_PREFIXES = %w(harvest_paradem harvest_partner)

class SyncService

  def initialize(api_service = HarvestService)
    @harvest_clients = []

    # Instantiate Harvest clients for each Org set in ENV
    ORGANIZATION_ENV_PREFIXES.each do |env_prefix|
      @harvest_clients << api_service.new(SyncService.env_vars_from_prefix(env_prefix))
    end
  end


  def sync_entries
    Entry.delete_all
    @harvest_clients.each do |client|
      entries = client.get_project_entries()
      organization = client.find_organization
      puts "getting entries for org: #{client.get_project} Entries count: #{entries.length}"
      entries.each{|e| valid_attrs = e.select{|x| Entry.attribute_names.index(x.to_s)}; ar=organization.entries.create(valid_attrs); puts "#{e.errors.full_messages.to_sentence}" if ar.errors.any? }
    end
  end

  def sync_users
    User.delete_all

    # TODO: We may have to signify organization our own way
    @harvest_clients.each do |client|
      users = client.get_users
      organization = client.find_organization
      puts "Syncing users from Harvest. Users count: #{users.length}. Org: #{organization.id}"
      users.each{|u| valid_attrs = u.select{|x| User.attribute_names.index(x.to_s)}; ar=organization.users.create(valid_attrs); puts "#{e.errors.full_messages.to_sentence}" if ar.errors.any? }
    end
  end

  def sync_projects
    Project.delete_all

    @harvest_clients.each do |client|
      project = client.get_project
      organization = client.find_organization
      valid_attrs = project.select{|x| Project.attribute_names.index(x.to_s)}
      organization.projects.create(valid_attrs)
    end
  end

  def sync_tasks
    Task.delete_all

    @harvest_clients.each do |client|
      tasks = client.get_tasks
      organization = client.find_organization
      tasks.each{|t| valid_attrs = t.select{|x| Task.attribute_names.index(x.to_s)}; ar=organization.tasks.create(valid_attrs); puts "#{e.errors.full_messages.to_sentence}" if ar.errors.any? }
    end
  end

  def self.env_vars_from_prefix(prefix)
    {
      subdomain: ENV["#{prefix}_subdomain"],
      username: ENV["#{prefix}_username"],
      password: ENV["#{prefix}_password"],
      project_id: ENV["#{prefix}_project_id"]
    }
  end

end
