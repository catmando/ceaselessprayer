require 'rails_helper'

RSpec.describe PrayerResource, type: :resource do
  describe 'serialization' do
    let!(:prayer) { create(:prayer) }

    it 'works' do
      render
      data = jsonapi_data[0]
      expect(data.id).to eq(prayer.id)
      expect(data.jsonapi_type).to eq('prayers')
    end
  end

  describe 'filtering' do
    let!(:prayer1) { create(:prayer) }
    let!(:prayer2) { create(:prayer) }

    context 'by id' do
      before do
        params[:filter] = { id: { eq: prayer2.id } }
      end

      it 'works' do
        render
        expect(jsonapi_data.map(&:id)).to eq([prayer2.id])
      end
    end
  end

  describe 'sorting' do
    describe 'by id' do
      let!(:prayer1) { create(:prayer) }
      let!(:prayer2) { create(:prayer) }

      context 'when ascending' do
        before do
          params[:sort] = 'id'
        end

        it 'works' do
          render
          expect(jsonapi_data.map(&:id)).to eq([
            prayer1.id,
            prayer2.id
          ])
        end
      end

      context 'when descending' do
        before do
          params[:sort] = '-id'
        end

        it 'works' do
          render
          expect(jsonapi_data.map(&:id)).to eq([
            prayer2.id,
            prayer1.id
          ])
        end
      end
    end
  end

  describe 'sideloading' do
    # ... your tests ...
  end
end
