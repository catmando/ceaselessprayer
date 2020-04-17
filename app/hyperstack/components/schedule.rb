class Schedule < Markdown
MARKDOWN = <<MARKDOWN
### Coming Soon!

For now please just go to the prayer page and pray!

MARKDOWN
  render do
    DIV(style: { marginTop: 75, marginBottom: 100 }) do
      papers
    end
  end

end
