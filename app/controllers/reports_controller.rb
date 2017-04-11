class ReportsController < ApplicationController
  def index
    @groups = Entry.includes(:user, :project, :task, :organization).group_entries(group_by_param)
  end

  private

  def group_by_param
    params[:group_by].present? ? params[:group_by].downcase : "user"
  end
end
