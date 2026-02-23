class BugPolicy < ApplicationPolicy
  def index?
    user.admin? || user.project_manager?
  end

  def show?
    user.admin? || user.project_manager?
  end

  def create?
    user.tester?
  end

  def update?
    user.admin? || user.project_manager? || user.tester?
  end

  def destroy?
    user.admin?
  end
end
