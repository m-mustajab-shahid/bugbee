class Bug < ApplicationRecord
  # Validations
  enum :priority, { low: "low", medium: "medium", high: "high", critical: "critical" }
  enum :severity, { minor: "minor", major: "major", blocker: "blocker" }
  enum :status, { open: "open", in_progress: "in-progress", assigned: "assigned", resolved: "resolved", closed: "closed", reopened: "reopened" }
  validates :title, presence: true, length: { in: 5..150 }

  # Relationship
  has_many :comments, as: :commentable
  belongs_to :project
  belongs_to :reporter, class_name: "User", foreign_key: :reporter_id
  belongs_to :assignee, class_name: "User", foreign_key: :assignee_id, optional: true

  # Scopes
  scope :developer_bugs, ->(user) { where(assignee_id: user.id) }
  scope :tester_bugs, ->(user) { where(reporter_id: user.id) }

  def admin?
    role == "admin"
  end

  def project_manager?
    role == "project_manager"
  end

  def developer?
    role == "developer"
  end

  def tester?
    role == "tester"
  end
end
