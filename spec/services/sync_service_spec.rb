require 'rails_helper'

class FakeHarvestService
  def initialize(opts); end
  def get_project_entries; end
  def find_organization; end
  def get_users; end
  def get_project; end
  def get_tasks; end
end

RSpec.describe HarvestService, type: :service do
  let (:service) { SyncService.new(FakeHarvestService) }
  let! (:org){ Organization.create name: 'test', code: 't', harvest_project: '99' }
  let (:entry) { FactoryGirl.build(:entry) }

  before do
    allow_any_instance_of(FakeHarvestService).to receive(:find_organization).and_return(org)
    allow_any_instance_of(FakeHarvestService).to receive(:get_project_entries).and_return(org)
  end

  context 'initialize' do
    before{ expect(FakeHarvestService).to receive(:new).twice}
    it 'builds service objects' do
      service
    end
  end

  context '#sync_entries' do
    # TODO
  end
end
