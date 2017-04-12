FactoryGirl.define do

  factory :entry, class: Harvest::TimeEntry do
    details "UX"
    spent_at "2011-03-31"
    hours 1
  end

end
