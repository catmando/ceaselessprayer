class Overview < HyperComponent
  def text
<<OverviewText
    Join people from around the world in prayer for God's mercy, for our repentance, and the granting of wisdom, compassion, healing and strength in this
    time of trial.

    We invite you to pray with the help of this simple app, just a few minutes a day.  We include a variety of prayers and helpful materials.  Let us light
    up the map of the world in ceaseless prayer to our merciful Lord.
OverviewText
  end

  def font_size
    if Window.height * Window.width > 1_000_000
      puts "font_size: 30"
      30
    elsif Window.height * Window.width > 400 * 700
      puts "font_size: 20"
      20
    else
      puts "font_size: 15"
      15
    end
  end

  render do
    DIV(style: { fontSize: font_size, marginBottom: 100 }) do
      Mui::Paper(elevation: 3, style: {padding: 5, marginTop: 5}) do
        text.split("\n\n").each { |p| P(style: { marginTop: 0 }) { p } }
      end
    end
  end
end
