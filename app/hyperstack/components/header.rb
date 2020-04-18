class Header < HyperComponent

  def menu_link(path, text)
    return if path == App.location.pathname

    Mui::MenuItem() { text }
    .on(:click) do
      Footer.push_path(path)
      mutate @anchor = nil
    end
  end
  render(DIV, style: {flexGrow: 1}) do
    Mui::AppBar(position: :fixed, id: 'header', size: :large) do
      Mui::Toolbar() do
        Mui::IconButton(edge: :start, color: :inherit, aria: {label: :menu, controls: :menu, haspopup: true}) do
          Icon::Menu()
        end.on(:click) { |e| mutate @anchor = e.target }
        # puts "window width: #{WindowDims.width} height: #{WindowDims.height}"
        'Join us in world wide prayer for healing'
      end
    end
    Mui::Menu(:keepMounted, id: :menu, anchorEl: @anchor.to_n, open: !!@anchor) do
      menu_link('/home', 'Home')
      menu_link('/about', 'About')
    end.on(:close) { mutate @anchor = nil } if @anchor
  end
end

# <Button aria-controls="simple-menu" aria-haspopup="true" onClick={handleClick}>
#   Open Menu
# </Button>


# <AppBar position="static">
#   <Toolbar>
#     <IconButton edge="start" className={classes.menuButton} color="inherit" aria-label="menu">
#       <MenuIcon />
#     </IconButton>
#     <Typography variant="h6" className={classes.title}>
#       News
#     </Typography>
#     <Button color="inherit">Login</Button>
#   </Toolbar>
# </AppBar>

# <Menu
#   id="simple-menu"
#   anchorEl={anchorEl}
#   keepMounted
#   open={Boolean(anchorEl)}
#   onClose={handleClose}
# >
#   <MenuItem onClick={handleClose}>Profile</MenuItem>
#   <MenuItem onClick={handleClose}>My account</MenuItem>
#   <MenuItem onClick={handleClose}>Logout</MenuItem>
# </Menu>
