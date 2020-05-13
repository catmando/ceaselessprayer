require 'rails_helper'

RSpec.describe "prayers#index", type: :request do
  let(:params) { {} }

  subject(:make_request) do
    jsonapi_get "/api/v1/prayers", params: params
  end

  describe 'basic fetch' do
    let!(:prayer1) { create(:prayer) }
    let!(:prayer2) { create(:prayer) }

    it 'works' do
      expect(PrayerResource).to receive(:all).and_call_original
      make_request
      expect(response.status).to eq(200), response.body
      expect(d.map(&:jsonapi_type).uniq).to match_array(['prayers'])
      expect(d.map(&:id)).to match_array([prayer1.id, prayer2.id])
    end
  end
end
