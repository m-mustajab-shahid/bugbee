class BugPolicy < ApplicationPolicy
  def index?
    user.admin? || user.project_manager?
  end

  def show?
    user.admin? || user.project_manager?
  end

  def create?
    user.admin? || user.project_manager?
  end

  def update?
    user.admin? || user.project_manager?
  end

  def destroy?
    user.admin?
  end
end
