class SyncService

  def initialize(api_service = HarvestService)
    @api_service = api_service
    @harvest_clients = []
    @prefixes = SyncService.organization_prefixes

    create_clients
  end

  def create_clients
    # Instantiate Harvest clients for each Org set in ENV
    @prefixes.each do |env_prefix|
      @harvest_clients << @api_service.new(SyncService.env_vars_from_prefix(env_prefix))
    end
  end

  def self.organization_prefixes
    Figaro.application.configuration.keys.map{ |k| k.match(/(harvest_[a-z]*)_w*/i).captures.first }.uniq
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
