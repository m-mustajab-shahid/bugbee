class DashboardController < ApplicationController
  before_action :authenticate_user!
  layout "admin"

  def index
    @total_users = User.count
    @total_projects = Project.count
    @total_open_bugs = Bug.where(status: "open").count
    @total_assigned_bugs = Bug.where(status: "assigned").count
  end
end
