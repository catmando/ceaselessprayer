class Done < Markdown
MARKDOWN = <<MARKDOWN
### Coming Soon!
Thanks for Praying with Us!

What's next?

+ Come back often!  Help us light up the world!
+ Tell you friends.
+ Checkout the About Page for more info.

MARKDOWN
  render do
    DIV(style: { marginTop: 75, marginBottom: 100 }) do
      papers
    end
  end

end
