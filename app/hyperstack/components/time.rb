class Time
  def distance_from_now_in_words
    now = Time.now
    distance_in_minutes = ((now - self) / 60.0).round

    case distance_in_minutes
    when 0..1             then now-self < 30 ? 'now' : 'less than 1 minute ago'
    when 2                then now-self < 90 ? 'about 1 minute ago' : '2 minutes ago'
    when 3...45           then "#{distance_in_minutes} minutes ago"
    when 45...90          then "about 1 hour ago"
      # 90 mins up to 24 hours
    when 90...1440        then "#{(distance_in_minutes.to_f / 60.0).round} hours ago"
      # 24 hours up to 42 hours
    when 1440...2520      then "about 1 day ago"
      # 42 hours up to 30 days
    when 2520...43200     then "#{(distance_in_minutes.to_f / 1440.0).round} days ago"
      # 30 days up to 60 days
    else
      "more than a month ago"
    end
  end
end    
