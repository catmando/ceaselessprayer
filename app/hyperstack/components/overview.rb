class Overview < HyperComponent
  def text
<<OverviewText
    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. In ornare quam viverra orci sagittis eu volutpat odio.

    Nec feugiat nisl pretium fusce id velit ut. Integer eget aliquet nibh praesent tristique magna sit. Arcu ac tortor dignissim convallis aenean et.
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
    DIV(style: { fontSize: font_size, marginBottom: 100 }) do # 20 works for w 360 h 640,
      text.split("\n").each { |p| P { p }}
    end
  end
end
