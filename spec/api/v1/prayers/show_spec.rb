require 'rails_helper'

RSpec.describe "prayers#show", type: :request do
  let(:params) { {} }

  subject(:make_request) do
    jsonapi_get "/api/v1/prayers/#{prayer.id}", params: params
  end

  describe 'basic fetch' do
    let!(:prayer) { create(:prayer) }

    it 'works' do
      expect(PrayerResource).to receive(:find).and_call_original
      make_request
      expect(response.status).to eq(200)
      expect(d.jsonapi_type).to eq('prayers')
      expect(d.id).to eq(prayer.id)
    end
  end
end
