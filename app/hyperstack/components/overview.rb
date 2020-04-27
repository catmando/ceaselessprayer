class Overview < HyperComponent

MARKDOWN = <<MARKDOWN
Join people from around the world in prayer for God's mercy, for our repentance, and the granting of wisdom, compassion, healing and strength in this
time of trial.

We invite you to pray with the help of this simple app, just a few minutes a day.  We include a variety of prayers and helpful materials.  Let us light
up the map of the world in ceaseless prayer to our merciful Lord.
MARKDOWN


  def font_size
    if WindowDims.height * WindowDims.width > 1_000_000
      30
    elsif WindowDims.height * WindowDims.width > 400 * 700
      20
    else
      15
    end
  end

  styles do
    case WindowDims.area
    when :large
      { container: { opacity: 0.8, fontSize: 30, marginBottom: 200 }, paper: { padding: 30, marginTop: 10 } }
    when :medium
      { container: { opacity: 0.8, fontSize: 17, marginBottom: 100 }, paper: { padding: 5, marginTop: 5 } }
    else
      { container: { opacity: 0.8, fontSize: 13, marginBottom: 100 }, paper: { padding: 5, marginTop: 5 } }
    end
  end

  render do
    DIV(style(:container), id: :overview) do
      Mui::Paper(style(:paper), elevation: 3) do
        MARKDOWN.split("\n\n").each { |p| P(style: { marginTop: 0 }) { p } }
      end
    end
  end
end
