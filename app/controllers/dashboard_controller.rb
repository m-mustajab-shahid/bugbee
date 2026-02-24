class DashboardController < ApplicationController
  before_action :authenticate_user!
  layout "admin"

  def index
    @total_users = User.count
    @total_projects = Project.count
    @total_open_bugs = Bug.where(status: "open").count
    @total_closed_bugs = Bug.where(status: "closed").count
    @bugs = case current_user.role
    when "developer" then Bug.where(assignee_id: current_user.id).order(created_at: :desc).limit(8)
    when "tester"    then Bug.where(reporter_id: current_user.id).order(created_at: :desc).limit(8)
    else
      Bug.where(project_id: current_user.projects).order(created_at: :desc).limit(8)
    end
  end
end
