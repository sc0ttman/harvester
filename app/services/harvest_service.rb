require 'harvested'

class HarvestService

  def initialize(params)
    @subdomain  = params[:subdomain]
    @username   = params[:username]
    @password   = params[:password]
    @project_id = params[:project_id]
    @client   ||= Harvest.hardy_client(subdomain: @subdomain, username: @username, password: @password)
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

end
