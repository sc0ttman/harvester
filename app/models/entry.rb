class Entry < ApplicationRecord
  belongs_to :user, optional: true # Opt out of mandatory association validation
  belongs_to :project, optional: true
  belongs_to :task, optional: true
end
