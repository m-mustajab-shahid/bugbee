class BugsController < ApplicationController
  layout "admin"
  before_action :authenticate_user!
  before_action :set_user
  before_action :set_bug, only: [ :show, :edit, :update, :destroy, :assign_developer, :changet_to_in_progress, :change_to_close, :change_to_reopen, :change_to_resolve ]
  before_action :set_project, only: [ :index, :new, :show, :create,  :edit, :update, :destroy, :assign_developer, :changet_to_in_progress, :change_to_close, :change_to_reopen, :change_to_resolve, :add_bug_comments ]

  def index
    per_page = params[:per_page].presence || 3
    @bugs = Bug.where(project_id: params[:project_id])
    # TODO: Move it to model level scopes (Done)
    if current_user.role == "developer"
      @bugs = @bugs.developer_bugs(@user)
    end
    if current_user.role == "tester"
      @bugs = @bugs.tester_bugs(@user)
    end
    # TODO: convert into single filter map (OPTIONAL)
    @bugs = @bugs.where(status: params[:status]) if params[:status].present?
    @bugs = @bugs.where(priority: params[:priority]) if params[:priority].present?
    @bugs = @bugs.where(severity: params[:severity]) if params[:severity].present?
    @bugs = @bugs.where(assignee_id: params[:assignee_id]) if params[:assignee_id].present?
    if params[:start_date].present? && params[:end_date].present?
      @bugs = @bugs.where(start_date: params[:start_date]..params[:end_date])
    end
    @bugs = @bugs.where("title LIKE ?", params[:search] + "%") if params[:search].present?
    @bugs = @bugs.page(params[:page]).per(per_page)
  end

  def show
    @developers = @project.users.where(role: "developer").where(status: true)
    per_page = params[:per_page].presence || 3
    @comments = @bug.comments.page(params[:page]).per(per_page)
  end

  def new
    authorize Bug
    @bug = @project.bugs.build
  end

  def create
    authorize Bug
    @bug = @project.bugs.build(bug_params)
    @bug.reporter = @user
    if @bug.save
      redirect_to project_bug_path(@project, @bug), notice: "Bug was successfully created!"
    else
      flash.now[:alert] = @bug.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize Bug
  end

  def update
    authorize Bug
    @bug = @project.bugs.find(params[:id])
    if @bug.update(bug_params)
      redirect_to project_bug_path(@project, @bug), notice: "Bug was successfully updated!"
    else
      flash.now[:alert] = @bug.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize User
    @bug.destroy
    redirect_to project_bugs_path(@project), notice: "Bug deleted successfully!"
  end

  def add_bug_comments
    @bug = Bug.find(params[:id])
    @comment = @bug.comments.new(body: params[:body], user_id: current_user.id)
    if @comment.save
      redirect_to project_bug_path(@project, @bug), notice: "Comment added!"
    else
      error_message = @comment.errors.full_messages.to_sentence
      redirect_to project_bug_path(@project, @bug), alert: error_message
    end
  end

  def assign_developer
    @bug = @project.bugs.find(params[:id])
    @bug.status = "assigned"
    @user = User.find(params[:bug][:assignee_id])
    if @bug.update(assignee_id: params[:bug][:assignee_id])
      NotifierMailer.welcome_email(@user, @bug, @project).deliver_now
      redirect_to project_bug_path(@project, @bug), notice: "Developer assigned successfully!"
    else
      flash.now[:alert] = @bug.errors.full_messages.to_sentence
      render :show, status: :unprocessable_entity
    end
  end

  def changet_to_in_progress
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
    @bug = @project.bugs.find(params[:id])
    if @bug.update(status: "closed")
      redirect_to project_bug_path(@project, @bug), notice: "Status change to Closed"
    else
      flash.now[:alert] = @bug.errors.full_messages.to_sentence
      render :show, status: :unprocessable_entity
    end
  end

  def change_to_reopen
    @bug = @project.bugs.find(params[:id])
    if @bug.update(status: "reopened", start_date: nil, end_date: nil)
      redirect_to project_bug_path(@project, @bug), notice: "Status change to Reopened"
    else
      flash.now[:alert] = @bug.errors.full_messages.to_sentence
      render :show, status: :unprocessable_entity
    end
  end

  def change_to_resolve
    @bug = @project.bugs.find(params[:id])
    if @bug.update(status: "resolved", end_date: Date.today)
      redirect_to project_bug_path(@project, @bug), notice: "Status change to Resolved"
    else
      flash.now[:alert] = @bug.errors.full_messages.to_sentence
      render :show, status: :unprocessable_entity
    end
  end

  # TODO: Convert into State Machine (AASM) + single API
  private
  def set_bug
    @bug = Bug.find(params[:id])
    @comments = @bug.comments
  end

  def set_user
    @user = current_user
  end

  def set_project
    @project = Project.find(params[:project_id])
  end

  def bug_params
    params.require(:bug).permit(:title, :description, :step_to_reproduce, :status, :priority, :severity, :actual_result, :expected_results, :start_date, :end_date)
  end
end
