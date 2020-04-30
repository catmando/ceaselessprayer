class Overview < HyperComponent

MARKDOWN = <<MARKDOWN
Join people from around the world in prayer for God's mercy, for our repentance, and the granting of wisdom, compassion, healing and strength in this
time of trial.

We invite you to pray with the help of this simple app, just a few minutes a day.  We include a variety of prayers and helpful materials.  Let us light
up the map of the world in ceaseless prayer to our merciful Lord.
MARKDOWN

  styles do
    case WindowDims.area
    when :large
      { container: ics.merge(opacity: 0.8, fontSize: 25), paper: { padding: 30, marginTop: 10 } }
    when :medium
      { container: ics.merge(opacity: 0.8, fontSize: 17), paper: { padding: 5, marginTop: 5 } }
    else
      { container: ics.merge(opacity: 0.8, fontSize: 14), paper: { padding: 5, marginTop: 5 } }
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
