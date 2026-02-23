class BugsController < ApplicationController
  layout "admin"
  before_action :authenticate_user!
  before_action :set_bug, only: [ :show, :edit, :update, :destroy, :assign_developer, :changet_to_in_progress, :change_to_close, :change_to_reopen, :change_to_resolve ]
def index
  @project = Project.find(params[:project_id])
  per_page = params[:per_page].presence || 3

  @bugs = Bug.where(project_id: params[:project_id])
  if current_user.roles == "developer"
    @bugs = @bugs.where(assignee_id: current_user.id)
  end
  if current_user.roles == "tester"
    @bugs = @bugs.where(reporter_id: current_user.id)
  end

  @bugs = @bugs.where(status: params[:status]) if params[:status].present?
  @bugs = @bugs.where(priority: params[:priority]) if params[:priority].present?
  @bugs = @bugs.where(severity: params[:severity]) if params[:severity].present?
  @bugs = @bugs.where(assignee_id: params[:assignee_id]) if params[:assignee_id].present?
  @bugs = @bugs.where("title LIKE ?", params[:search] + "%") if params[:search].present?

  @bugs = @bugs.page(params[:page]).per(per_page)
end


  def show
  @project = Project.find(params[:project_id])
  @developers = @project.users.where(roles: "developer").where(status: true)
  @comments = @bug.comments
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



def add_bug_comments
  @project = Project.find(params[:project_id])
  @bug = Bug.find(params[:id])

  @comment = @bug.comments.new(body: params[:bug][:body], user_id: current_user.id)

  if @comment.save
    redirect_to project_bug_path(@project, @bug), notice: "Comment added!"
  else
    error_message = @comment.errors.full_messages.to_sentence
    redirect_to project_bug_path(@project, @bug), alert: error_message
  end
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
    @user = User.find(params[:bug][:assignee_id])
    if @bug.update(assignee_id: params[:bug][:assignee_id])
      NotifierMailer.welcome_email(@user).deliver_now
      redirect_to project_bug_path(@project, @bug), notice: "Developer assigned successfully!"
    else
      flash.now[:alert] = @bug.errors.full_messages.to_sentence
      render :show, status: :unprocessable_entity
    end
  end

  def changet_to_in_progress
    @project = Project.find(params[:project_id])
    @bug = @project.bugs.find(params[:id])
    if @bug.update(status: "in-progress", start_date: Date.today)
        @comments = @bug.comments
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
    if @bug.update(status: "reopened", start_date: nil, end_date: nil)
      redirect_to project_bug_path(@project, @bug), notice: "Status change to In-Progess"
    else
      flash.now[:alert] = @bug.errors.full_messages.to_sentence
      render :show, status: :unprocessable_entity
    end
  end

  def change_to_resolve
    @project = Project.find(params[:project_id])
    @bug = @project.bugs.find(params[:id])
    if @bug.update(status: "resolved", end_date: Date.today)
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
    @comments = @bug.comments
  end

  def bug_params
    params.require(:bug).permit(:title, :description, :step_to_reproduce, :status, :priority, :severity, :actual_result, :expected_results, :start_date, :end_date)
  end
end
