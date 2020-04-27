class Markdown < HyperComponent
  REMARKABLE = `new Remarkable({html: true})`

  styles do
    {
      container: {
        opacity: 0.5,
        marginTop: Header.height + 10,
        marginBottom: 150,
        fontSize: [WindowDims.height * WindowDims.width / 70_000, 14].max
      },
      paper: { padding: [WindowDims.height * WindowDims.width / 80_000, 5].max, marginTop: 5, marginBottom: 5 }
    }
  end

  def papers
    Mui::Container() do
      Mui::Grid(:container, spacing: 1) do
        Mui::Grid(:item, xs: 12, sm: 8) do
          self.class::MARKDOWN.split("\n~~~~").each do |paper|
            Mui::Paper(style(:paper), elevation: 3) do
              DIV(dangerously_set_inner_HTML: { __html:  `#{Markdown::REMARKABLE}.render(#{paper})`})
            end
          end
        end
      end
    end
  end
end
