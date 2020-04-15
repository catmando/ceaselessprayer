class Markdown < HyperComponent
  REMARKABLE = `new Remarkable({html: true})`
  def papers
    self.class::MARKDOWN.split("\n~~~~").each do |paper|
      Mui::Paper(elevation: 3, style: {padding: 5, marginTop: 5, marginBottom: 5}) do
        DIV(dangerously_set_inner_HTML: { __html:  `#{Markdown::REMARKABLE}.render(#{paper})`})
      end
    end
  end
end
