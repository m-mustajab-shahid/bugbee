class ProjectsController < ApplicationController
  layout "admin"
  before_action :authenticate_user!
  before_action :set_project, only: [ :show, :edit, :update, :destroy ]

  def index
    per_page = params[:per_page].present? ? params[:per_page].to_i : 3
  @projects = current_user.projects.page(params[:page]).per(per_page)
  end

  def new
            authorize Project

    @project = Project.new
  end

  def create
    authorize Project
    @project = Project.new(project_params)
    @project.users << current_user if current_user
    if @project.save
    redirect_to projects_path, notice: "Project was successfully created!"
    else
    flash.now[:alert] = @project.errors.full_messages.to_sentence
    render :new, status: :unprocessable_entity
    end
  end

  def show
    @users = @project.users
    @available_users = User.where.not(id: @users.pluck(:id))
  end

  def edit
    authorize Project
  end

  def update
    authorize Project

    if Project.update(project_params)
    redirect_to projects_path, notice: "Project was updated created!"
    else
    flash.now[:alert] = @project.errors.full_messages.to_sentence
    render :new, status: :unprocessable_entity
    end
  end


  def add_users
  @project = Project.find(params[:id])
  user_ids = params[:user_ids] || []

  if user_ids.any?
    @project.user_ids += user_ids.map(&:to_i)
    redirect_to @project, notice: "#{user_ids.size} user(s) added to project successfully!"
  else
    redirect_to @project, alert: "No users selected."
  end
  end

def remove_users
  @project = Project.find(params[:id])
  user = User.find(params[:user_id])

  if @project.users.delete(user)
    redirect_to @project, notice: "User removed successfully."
  else
    redirect_to @project, alert: "Error removing user."
  end
end



def destroy
      authorize Project

  @project.destroy
  redirect_to projects_path, notice: "Project deleted successfully!"
end




  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :start_date, :end_date, :description, :status)
  end
end
