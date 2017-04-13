FactoryGirl.define do

  # Harvested objects built from API results
  factory :harvest_entry, class: Harvest::TimeEntry do
    details "UX"
    spent_at "2011-03-31"
    hours { rand(1..10) }
    user_id 1
    project_id 1
    task_id 1
    organization_id 1
  end

  # http://ricostacruz.com/cheatsheets/ffaker.html
  factory :harvest_user, class: Harvest::User do
    cost_rate nil
    default_hourly_rate 0
    department nil
    email Faker::Internet.email
    first_name Faker::Name.first_name
    has_access_to_all_future_projects false
    is_active true
    is_admin false
    is_contractor false
    last_name Faker::Name.last_name
    telephone ""
    timezone "Mountain Time (US & Canada)"
    wants_newsletter false
    weekly_capacity 126000
  end

  factory :harvest_project, class: Harvest::Project do
    name Faker::Product.product
    client_id 5495408
    code Faker::Product.product
    cost_budget nil
    cost_budget_include_expenses false
    notes Faker::Lorem.sentence
    notify_when_over_budget false
    over_budget_notification_percentage 80.0
    over_budget_notified_at nil
  end

  factory :harvest_task, class: Harvest::Task do
    name Faker::Job.title
    billable_by_default false
    deactivated false
    default_hourly_rate 0
    is_default false
  end

  # local objects created from Harvested objects
  factory :organization do
    name Faker::Company.name
    code Faker::Company.suffix
    harvest_project 13618520
    harvest_subdomain Faker::Internet.domain_word
    harvest_username Faker::Internet.email
    harvest_password Faker::Lorem.word

    factory :organization_with_associations do
       after(:create) do |article|
         create(:comment, article: article)
       end
     end
  end

  factory :project do
    name Faker::Product.product
    code Faker::Product.product
    notes Faker::Lorem.sentence
    organization
  end


  factory :task do
    name Faker::Job.title
    organization
  end

  factory :user do
    email Faker::Internet.email
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    organization
  end

  factory :entry do
    notes "UX"
    spent_at "2011-03-31"
    hours { rand(1..10) }
    user
    project
    task
    organization
  end

  factory :admin do
    email Faker::Internet.email
    password 'secret123'
    password_confirmation { password }
  end


end
