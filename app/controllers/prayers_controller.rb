class PrayersController < ApplicationController
  def index
    prayers = PrayerResource.all(params)
    render jsonapi: prayers
  end

  def show
    prayer = PrayerResource.find(params)
    render jsonapi: prayer
  end

  def create
    prayer = PrayerResource.build(params)

    if prayer.save
      render jsonapi: prayer, status: 201
    else
      render jsonapi_errors: prayer
    end
  end
end
