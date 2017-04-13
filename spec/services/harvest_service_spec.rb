require 'rails_helper'

class FakeHarvestAPI
  def self.hardy_client(opts)
    FakeHardyClient.new(opts)
  end
end

class FakeHardyClient
  def initialize(opts); end
  def reports; end
  def users; end
  def tasks; end
  def projects; end
end

RSpec.describe HarvestService, type: :service do
  let (:harvest_credentials) {{
    subdomain: 'test',
    username:  'user',
    password:  'pass',
    project_id: '99'
  }}
  let (:service) { HarvestService.new(harvest_credentials, FakeHarvestAPI) }
  let! (:org){ Organization.create name: 'test', code: 't', harvest_project: harvest_credentials[:project_id] }

  context 'initialize' do
    it 'parses params properly' do
      expect(service.instance_variable_get(:@subdomain)).to eq harvest_credentials[:subdomain]
      expect(service.instance_variable_get(:@username)).to eq harvest_credentials[:username]
      expect(service.instance_variable_get(:@password)).to eq harvest_credentials[:password]
      expect(service.instance_variable_get(:@project_id)).to eq harvest_credentials[:project_id]
    end

    it "sends the hardy_client message to the api class" do
      expect(FakeHarvestAPI).to receive(:hardy_client).with(harvest_credentials.except(:project_id))
      service
    end
  end

  context '#get_project_entries' do
    it 'queries time entries for a project within a range' do
      expect_any_instance_of(FakeHardyClient).to receive_message_chain(:reports, :time_by_project)
      service.get_project_entries
    end
  end

  context '#get_users' do
    it 'queries harvest users' do
      expect_any_instance_of(FakeHardyClient).to receive_message_chain(:users, :all)
      service.get_users
    end
  end

  context '#get_tasks' do
    it 'queries harvest tasks' do
      expect_any_instance_of(FakeHardyClient).to receive_message_chain(:tasks, :all)
      service.get_tasks
    end
  end

  context '#get_project' do
    it 'queries harvest project' do
      expect_any_instance_of(FakeHardyClient).to receive_message_chain(:projects, :find)
      service.get_project
    end
  end

  context '#find_organization returns related organization object' do
    it 'returns the organization object of the' do
      expect(service.find_organization).to eq org
    end
  end

end
