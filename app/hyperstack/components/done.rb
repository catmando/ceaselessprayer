class Done < Markdown

  def markdown
<<MARKDOWN
### Thanks for Praying with Us!

What's next?

+ Come back often!  Light up the world!
+ Tell you friends!
+ Email us at [ceaselessprayers@gmail.com](mailto:ceaselessprayers@gmail.com)!
+ Checkout the About Page...

**NEW: Recent and Frequent Cities Pages!**

*See the menu on the top left corner for other pages.*
#{"\n**Bookmark us for quick loading, and automatic updates.**" if App.ready_to_install?}
MARKDOWN
  end

  styles do
    if WindowDims.height > 750 && WindowDims.width > 400
      { container: ics.merge(opacity: 0.8, fontSize: 25), paper: { padding: 30, marginTop: 10 } }
    elsif WindowDims.height > 500
      { container: ics.merge(opacity: 0.8, fontSize: 17), paper: { padding: 5, marginTop: 5 } }
    else
      { container: ics.merge(opacity: 0.8, fontSize: 12), paper: { padding: 5, marginTop: 5 } }
    end
  end

  render do
    DIV(style(:container), class: 'row content') do
      papers
    end
  end

end
