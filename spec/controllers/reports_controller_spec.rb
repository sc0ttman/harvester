require 'rails_helper'

RSpec.describe ReportsController, type: :controller do
  let(:entries) { FactoryGirl.create_list(:entry, 5) }

  context 'as anonymous user' do
    describe '#index' do
      before do
        entries
        get :index
      end

      it 'assigns all a hash of grouped results' do
        key, value = assigns[:groups].first
        expect(assigns[:groups]).to be_a(Hash)
        expect(value).to be_a(Array)
      end
    end
  end

end
