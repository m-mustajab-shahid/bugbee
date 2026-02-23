class DashboardController < ApplicationController
  before_action :authenticate_user!
  layout "admin"

  def index
    @total_users = User.count
    @total_projects = Project.count
    @total_open_bugs = Bug.where(status: "open").count
    @total_closed_bugs = Bug.where(status: "closed").count
    @bugs = case current_user.roles
    when "developer" then Bug.where(assignee_id: current_user.id)
    when "tester"    then Bug.where(reporter_id: current_user.id)
    else
  Bug.where(project_id: current_user.projects)
    end
    end
end
