class Markdown < HyperComponent
  REMARKABLE = `new Remarkable({html: true})`
  def self.markdown
    # @markdown ||=
    `#{REMARKABLE}.render(#{self::MARKDOWN})`
  end
  render { DIV(dangerously_set_inner_HTML: { __html: self.class.markdown }) }
end
