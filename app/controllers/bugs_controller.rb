class BugsController < ApplicationController
  layout "admin"
  before_action :authenticate_user!
  before_action :set_user
  before_action :set_bug, only: [ :show, :edit, :update, :destroy, :assign_developer, :change_status ]
  before_action :set_project, only: [ :index, :new, :show, :create,  :edit, :update, :destroy, :assign_developer, :change_status, :add_bug_comments ]

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
    # TODO: convert into single filter map (OPTIONAL) (Done)
    filtering_params = params.permit(:status, :priority, :severity, :assignee_id).compact_blank
    @bugs = @bugs.where(filtering_params)
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
    @allowed_status = @bug.aasm.permitted_transitions
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
    authorize @bug
    if @bug.destroy
      redirect_to project_bugs_path(@project), notice: "Bug deleted successfully!"
    else
      redirect_to project_bugs_path(@project), alert: "Bug could not be deleted!"
    end
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
    @user = User.find(params[:bug][:assignee_id])
    @bug.assign!
    if @bug.update(assignee_id: params[:bug][:assignee_id])
      NotifierMailer.welcome_email(@user, @bug, @project).deliver_later
      redirect_to project_bug_path(@project, @bug), notice: "Developer assigned successfully!"
    else
      flash.now[:alert] = @bug.errors.full_messages.to_sentence
      render :show, status: :unprocessable_entity
    end
  end

  def change_status
    @bug = @project.bugs.find(params[:id])
    new_status = params[:bug][:status]
    begin
      case new_status
      when "in_progress"
        @bug.start_date = Date.today
        @bug.start_progress! if @bug.may_start_progress?
      when "resolved"
        @bug.end_date = Date.today
        @bug.resolve! if @bug.may_resolve?
      when "closed"
        @bug.close! if @bug.may_close?
      when "assigned"
        @bug.assign! if @bug.may_assign?
        @bug.start_date = ""
        @bug.end_date = ""
      when "reopened"
        @bug.reopen! if @bug.may_reopen?
      else
        flash[:alert] = "Invalid status"
        redirect_to project_bug_path(@project, @bug) and return
      end

      if @bug.save
        @comments = @bug.comments
        redirect_to project_bug_path(@project, @bug), notice: "Status changed successfully"
      else
        flash.now[:alert] = @bug.errors.full_messages.to_sentence
        render :show, status: :unprocessable_entity
      end
    rescue AASM::InvalidTransition => e
      flash[:alert] = "Cannot change status: #{e.message}"
      redirect_to project_bug_path(@project, @bug)
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

  def bug_status
    params.require(:bug).permit(:status)
  end

  def bug_params
    params.require(:bug).permit(:title, :description, :step_to_reproduce, :status, :priority, :severity, :actual_result, :expected_results, :start_date, :end_date)
  end
end
