require 'rails_helper'

RSpec.describe PrayerResource, type: :resource do
  describe 'creating' do
    let(:payload) do
      {
        data: {
          type: 'prayers',
          attributes: { }
        }
      }
    end

    let(:instance) do
      PrayerResource.build(payload)
    end

    it 'works' do
      expect {
        expect(instance.save).to eq(true), instance.errors.full_messages.to_sentence
      }.to change { Prayer.count }.by(1)
    end
  end

  describe 'updating' do
    let!(:prayer) { create(:prayer) }

    let(:payload) do
      {
        data: {
          id: prayer.id.to_s,
          type: 'prayers',
          attributes: { } # Todo!
        }
      }
    end

    let(:instance) do
      PrayerResource.find(payload)
    end

    xit 'works (add some attributes and enable this spec)' do
      expect {
        expect(instance.update_attributes).to eq(true)
      }.to change { prayer.reload.updated_at }
      # .and change { prayer.foo }.to('bar') <- example
    end
  end

  describe 'destroying' do
    let!(:prayer) { create(:prayer) }

    let(:instance) do
      PrayerResource.find(id: prayer.id)
    end

    it 'works' do
      expect {
        expect(instance.destroy).to eq(true)
      }.to change { Prayer.count }.by(-1)
    end
  end
end
