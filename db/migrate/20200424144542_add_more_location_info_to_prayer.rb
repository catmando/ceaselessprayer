class AddMoreLocationInfoToPrayer < ActiveRecord::Migration[5.2]

  def up
    add_column :prayers, :country, :string
    add_column :prayers, :region_name, :string
    add_column :prayers, :city, :string
    add_column :prayers, :flag, :string

    Prayer.reset_column_information

    if Prayer.ipstack_access_key
      ip_data = Hash.new do |hash, key|
        puts "http://api.ipstack.com/#{key}?access_key=#{Prayer.ipstack_access_key}"
        uri = URI("http://api.ipstack.com/#{key}?access_key=#{Prayer.ipstack_access_key}")
        json = JSON.parse(Net::HTTP.get(uri)).with_indifferent_access
        hash[key] = {
          country: json[:country_name], region_name: json[:region_name],
          city: json[:city], flag: json[:location][:country_flag]
        }
      end

      Prayer.all.each do |prayer|
        prayer.update(ip_data[prayer.ip]) unless prayer.ip.blank?
      end
    else
      puts "IPStack not configured. Skipping."
    end
  end

  def down
    remove_column :prayers, :country
    remove_column :prayers, :region_name
    remove_column :prayers, :city
    remove_column :prayers, :flag
  end

end
