class Bug < ApplicationRecord
  validates :priority, inclusion: { in: %w[low medium high critical], message: "%{value} is not a valid bug priority" }
  validates :severity, inclusion: { in: %w[minor major blocker], message: "%{value} is not a valid bug severity" }
  validates :status, inclusion: { in: %w[open in-progress assigned resolved closed reopened], message: "%{value} is not a valid bug status" }
  validates :title, presence: true

  belongs_to :project
  belongs_to :reporter,
             class_name: "User",
             foreign_key: "reporter_id"
               belongs_to :assignee,
             class_name: "User",
             foreign_key: "assignee_id",
             optional: true
end
