class Entry < ApplicationRecord
  belongs_to :user, optional: true # Opt out of mandatory association validation
  belongs_to :project, optional: true
  belongs_to :task, optional: true
  belongs_to :organization, optional: true


  def self.group_entries(group_value)
    case group_value
    when 'date'
      all.group_by{ |e| e.spent_at}
    when 'task'
      all.group_by{ |e| e.task.name }
    when 'organization'
      all.group_by{ |e| e.organization.name }
    else #user
      all.group_by{ |e| e.user.full_name }
    end
  end

end
