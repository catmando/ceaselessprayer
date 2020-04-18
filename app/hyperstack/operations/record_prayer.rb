class RecordPrayer < Hyperstack::ControllerOp
  step :find_ip_address
  step :geolocate
  step :record

  def find_ip_address
  end

  def geolocate
  end

  def record
  end
end
