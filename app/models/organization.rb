class Organization < ApplicationRecord
  has_many :entries
  has_many :users
  has_many :projects
  has_many :tasks

  def configured_project
    projects.where(id: harvest_project).first
  end
end
