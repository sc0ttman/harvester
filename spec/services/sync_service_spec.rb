require 'rails_helper'

# Stub out class api
class FakeHarvestService
  def initialize(opts); end
  def subdomain; end
  def get_project_entries; end
  def find_organization; end
  def get_users; end
  def get_project; end
  def get_tasks; end
  def get_data_from_harvest(object, options={}); end
end

RSpec.describe HarvestService, type: :service do
  let (:service) { SyncService.new(FakeHarvestService) }
  let! (:org){ Organization.create name: 'test', code: 't', harvest_project: '99' }
  let (:entries) { FactoryGirl.build_list(:harvest_entry, 10) }
  let (:users) { FactoryGirl.build_list(:harvest_user, 2) }
  let (:project) { FactoryGirl.build(:harvest_project) }
  let (:tasks) { FactoryGirl.build_list(:harvest_task, 5) }
  let (:env){
    {
      harvest_partner_subdomain: "test",
      harvest_partner_username: "test@test.com",
      harvest_partner_password: "1234",
      harvest_partner_project_id: "12345678"
    }
  }

  # let (:project)

  before do
    allow_any_instance_of(FakeHarvestService).to receive(:find_organization).and_return(org)
    allow_any_instance_of(FakeHarvestService).to receive(:subdomain).and_return(org.name)
    allow_any_instance_of(FakeHarvestService).to receive(:get_data_from_harvest).with(:entry, {}).and_return(entries)
    allow_any_instance_of(FakeHarvestService).to receive(:get_data_from_harvest).with(:user, {}).and_return(users)
    allow_any_instance_of(FakeHarvestService).to receive(:get_data_from_harvest).with(:project, {}).and_return(project)
    allow_any_instance_of(FakeHarvestService).to receive(:get_data_from_harvest).with(:task, {}).and_return(tasks)

    # Stub out config keys
    stub_const('ENV', env)
  end

  context 'initialize' do
    let(:subject) { service }
    before{ expect(FakeHarvestService).to receive(:new)}
    it 'builds service objects' do
      subject
    end
  end

  context '#sync_entries' do
    let(:subject) { service.sync_data(:entry) }
    it 'creates entries for each Harvest account' do
      expect { subject }.to change(Entry, :count).by(10) # 10 for each account
    end
  end

  context '#sync_users' do
    let(:subject) { service.sync_data(:user) }
    it 'creates user for each Harvest account' do
      expect { subject }.to change(User, :count).by(2) # 2 for each account
    end
  end

  context '#sync_projects' do
    let(:subject) { service.sync_data(:project) }
    it 'creates projects for each Harvest account' do
      expect { subject }.to change(Project, :count).by(1) # 1 for each account
    end
  end

  context '#sync_tasks' do
    let(:subject) { service.sync_data(:task) }
    it 'creates tasks for each Harvest account' do
      expect { subject }.to change(Task, :count).by(5) # 5 for each account
    end
  end



end
