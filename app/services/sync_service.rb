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

  def sync_data(object_name, options = {})
    object = object_name.to_s.classify.constantize
    object.delete_all

    @harvest_clients.each do |client|
      organization = client.find_organization

      data = client.get_data_from_harvest(object_name, options)
      data = [data] unless data.is_a? Array # import requires array

      puts "Syncing #{object_name} data for #{client.subdomain}. Importing #{data.length} records."
      # Since everything belongs to this organization, add the key/value to
      # every result.
      data.each {|h| h[:organization_id] = organization.id }
      object.transaction do
        object.import(object.attribute_names, data, validate: false)
      end

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
