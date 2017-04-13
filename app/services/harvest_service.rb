require 'harvested'

class HarvestService
  attr_reader :client, :subdomain

  def initialize(params, api = Harvest )
    @subdomain  = params[:subdomain]
    @username   = params[:username]
    @password   = params[:password]
    @project_id = params[:project_id]
    @client   ||= api.hardy_client(subdomain: @subdomain, username: @username, password: @password)
  end

  def get_project_entries(from: Time.parse("01/01/2016"), to: Time.now)
    @client.reports.time_by_project(@project_id, from, to)
  end

  def get_users
    @client.users.all
  end

  def get_tasks
    @client.tasks.all(@project_id)
  end

  def get_project
    @project ||= @client.projects.find(@project_id)
  end

  def find_organization
    Organization.where(harvest_project: @project_id.to_i).first
  end

  def get_data_from_harvest(object_name, options={})
    case object_name.to_sym
    when :entry
      get_project_entries(options)
    when :user
      get_users
    when :task
      get_tasks
    when :project
      get_project
    end
  end

end
