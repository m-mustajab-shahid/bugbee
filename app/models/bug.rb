class Bug < ApplicationRecord
  include AASM
  # Validations
  enum :priority, { low: "low", medium: "medium", high: "high", critical: "critical" }
  enum :severity, { minor: "minor", major: "major", blocker: "blocker" }
  validates :title, presence: true, length: { in: 5..150 }

  # Relationships
  has_many :comments, as: :commentable
  belongs_to :project
  belongs_to :reporter, class_name: "User"
  belongs_to :assignee, class_name: "User", optional: true

  # Scopes
  scope :developer_bugs, ->(user) { where(assignee_id: user.id) }
  scope :tester_bugs, ->(user) { where(reporter_id: user.id) }

  # AASM State Machine
  # options_list -> [in_progress, assigned, cancel]
  aasm column: :status do
    state :open, initial: true
    state :assigned
    state :in_progress
    state :resolved
    state :closed
    state :reopened

    event :assign do
      transitions from: [ :open, :reopened ], to: :assigned
    end

    event :start_progress do
      transitions from: :assigned, to: :in_progress
    end

    event :resolve do
      transitions from: :in_progress, to: :resolved
    end

    event :close do
      transitions from: :resolved, to: :closed
    end

    event :reopen do
      transitions from: [ :resolved, :closed ], to: :reopened
    end
  end
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
