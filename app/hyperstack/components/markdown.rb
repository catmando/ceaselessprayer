class Markdown < HyperComponent
  REMARKABLE = `new Remarkable({html: true})`

  styles do
    {
      container: {
        fontSize: [WindowDims.height * WindowDims.width / 70_000, 17].max,
        overflow: :auto
      },
      paper: {
        background: 'rgba(255, 255, 255, 0.6)',
        padding: [WindowDims.height * WindowDims.width / 80_000, 5].max, marginTop: 5, marginBottom: 5 }
    }
  end

  def markdown
    self.class::MARKDOWN
  end


  def papers
    Mui::Container() do
      Mui::Grid(:container, spacing: 1) do
        Mui::Grid(:item, xs: 12, sm: 8) do
          markdown.split("\n~~~~").each do |paper|
            Mui::Paper(styles(:paper), elevation: 3) do
              DIV(dangerously_set_inner_HTML: { __html:  `#{Markdown::REMARKABLE}.render(#{paper})`})
            end
          end
        end
      end
    end
  end
end
