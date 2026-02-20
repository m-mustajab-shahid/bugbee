class BugsController < ApplicationController
  layout "admin"
  before_action :set_bug, only: [ :show, :edit, :update, :destroy ]
  def index
    @bugs = Bug.where(project_id: params[:project_id])
  end

  def show
    @project = Project.find(params[:project_id])
    @developers = User.where(roles: "developer")
  end

  def new
    @project = Project.find(params[:project_id])
    @bug = @project.bugs.build
  end

def create
  @project = Project.find(params[:project_id])

  @bug = @project.bugs.build(bug_params)
  @bug.reporter = current_user

  if @bug.save
    redirect_to project_bug_path(@project, @bug), notice: "Bug was successfully created!"
  else
    flash.now[:alert] = @bug.errors.full_messages.to_sentence
    render :new, status: :unprocessable_entity
  end
end

  def edit
        @project = Project.find(params[:project_id])
  end

def update
  @project = Project.find(params[:project_id])
  @bug = @project.bugs.find(params[:id])
  if @bug.update(bug_params)
    redirect_to project_bug_path(@project, @bug), notice: "Bug was successfully updated!"
  else
    flash.now[:alert] = @bug.errors.full_messages.to_sentence
    render :edit, status: :unprocessable_entity
  end
end

def assign_developer
    @project = Project.find(params[:project_id])
  @bug = @project.bugs.find(params[:id])

  if @bug.update(assignee_id: params[:bug][:assignee_id])
    redirect_to project_bug_path(@project, @bug), notice: "Developer assigned successfully!"
  else
    flash.now[:alert] = @bug.errors.full_messages.to_sentence
    render :show, status: :unprocessable_entity
  end
end

  def destroy
  end


  private

  def set_bug
    @bug = Bug.find(params[:id])
  end

  def bug_params
    params.require(:bug).permit(:title, :description, :step_to_reproduce, :status, :priority, :severity, :actual_result, :expected_results)
  end
end
