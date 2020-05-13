class DistanceFromNow < HyperComponent

  param :time

  def distance_from_now_in_words
    distance_in_seconds = @now - time
    distance_in_minutes = (distance_in_seconds / 60.0).round

    case distance_in_seconds
    when 0..30             then 'now'
    when 30..45            then 'less than 1 minute ago'
    when 45..90            then 'about 1 minute ago'
    when 90..45*60         then "#{distance_in_minutes} minutes ago"
    when 45*60..90*60      then "about 1 hour ago"
      # 90 mins up to 24 hours
    when 90*60..1440*60    then "#{(distance_in_minutes.to_f / 60.0).round} hours ago"
      # 24 hours up to 42 hours
    when 1440*60..2520*60  then "about 1 day ago"
      # 42 hours up to 30 days
    when 2520*60..43200*60 then "#{(distance_in_minutes.to_f / 1440.0).round} days ago"
      # 30 days up to 60 days
    else
      "more than a month ago"
    end
  end

  def update_in
    distance_in_minutes = ((@now - time) / 60.0).round

    case distance_in_minutes
    when 0..1    then (120 - (@now - time)) % 30
    when 1..45   then 1.minute
    when 45..90  then (distance_in_minutes-45) * 60
    when 90..120 then (distance_in_minutes-90) * 60
    else
      60 * 60
    end
  end

  before_mount do
    @now = Time.now
  end

  after_render do
    after(update_in.seconds) { mutate @now = Time.now }
  end

  render do
    DIV(style: ics) { distance_from_now_in_words }
  end
end
