class BugsController < ApplicationController
  layout "admin"
  before_action :authenticate_user!
  before_action :set_bug, only: [ :show, :edit, :update, :destroy ]
  def index
    per_page = params[:per_page].present? ? params[:per_page].to_i : 3
    @bugs = Bug.where(project_id: params[:project_id]).page(params[:page]).per(per_page)
    if current_user.roles === "developer" || current_user == "tester"
    @bugs = Bug.where(project_id: params[:project_id])
    .where(assignee_id: current_user.id)
              .page(params[:page])
              .per(per_page)
    end
  end

  def show
  @project = Project.find(params[:project_id])
  @developers = @project.users.where(roles: "developer")
  end

  def new
              authorize Bug

    @project = Project.find(params[:project_id])
    @bug = @project.bugs.build
  end

  def create
              authorize Bug

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
          authorize Bug

        @project = Project.find(params[:project_id])
  end

  def update
              authorize Bug

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
    @bug.status = "assigned"
    if @bug.update(assignee_id: params[:bug][:assignee_id])
      redirect_to project_bug_path(@project, @bug), notice: "Developer assigned successfully!"
    else
      flash.now[:alert] = @bug.errors.full_messages.to_sentence
      render :show, status: :unprocessable_entity
    end
  end

  def changet_to_in_progress
    @project = Project.find(params[:project_id])
    @bug = @project.bugs.find(params[:id])
    if @bug.update(status: "in-progress")
      redirect_to project_bug_path(@project, @bug), notice: "Status change to In-Progess"
    else
      flash.now[:alert] = @bug.errors.full_messages.to_sentence
      render :show, status: :unprocessable_entity
    end
  end

  def change_to_close
    @project = Project.find(params[:project_id])
    @bug = @project.bugs.find(params[:id])
    if @bug.update(status: "closed")
      redirect_to project_bug_path(@project, @bug), notice: "Status change to In-Progess"
    else
      flash.now[:alert] = @bug.errors.full_messages.to_sentence
      render :show, status: :unprocessable_entity
    end
  end

  def change_to_reopen
    @project = Project.find(params[:project_id])
    @bug = @project.bugs.find(params[:id])
    if @bug.update(status: "reopened")
      redirect_to project_bug_path(@project, @bug), notice: "Status change to In-Progess"
    else
      flash.now[:alert] = @bug.errors.full_messages.to_sentence
      render :show, status: :unprocessable_entity
    end
  end

  def change_to_resolve
    @project = Project.find(params[:project_id])
    @bug = @project.bugs.find(params[:id])
    if @bug.update(status: "resolved")
      redirect_to project_bug_path(@project, @bug), notice: "Status change to Resolved"
    else
      flash.now[:alert] = @bug.errors.full_messages.to_sentence
      render :show, status: :unprocessable_entity
    end
  end

  def destroy
          authorize User

    @project = Project.find(params[:project_id])
    @bug.destroy
    redirect_to project_bugs_path(@project), notice: "Bug deleted successfully!"
  end


  private

  def set_bug
    @bug = Bug.find(params[:id])
  end

  def bug_params
    params.require(:bug).permit(:title, :description, :step_to_reproduce, :status, :priority, :severity, :actual_result, :expected_results)
  end
end
