class PrayerResource < ApplicationResource
  attribute :lat, :big_decimal
  attribute :long, :big_decimal
  attribute :country, :string
  attribute :region_name, :string
  attribute :city, :string
  attribute :flag, :string
  attribute :created_at, :date, writable: false
end
