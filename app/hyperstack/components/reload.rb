class Reload < HyperComponent
  render do
    DIV(style: {
      position: :fixed,
      padding: 0, margin: 0, top: 0, left: 0,
      height: '100vh', width: '100vw',
      background: "no-repeat  url('https://images.squarespace-cdn.com/content/v1/56bf85d4c6fc0810908bcfb7/1535478156642-GHVVWDHWXOFSW620XRN7/ke17ZwdGBToddI8pDm48kCgk598Qv4yYYuN3yVF14mx7gQa3H78H3Y0txjaiv_0fDoOvxcdMmMKkDsyUqMSsMWxHk725yiiHCCLfrh8O1z5QPOohDIaIeljMHgDF5CVlOqpeNLcJ80NK65_fV7S1UWKjajHPmfE1cqP9XoqhFHmoX9tOBJQJrb7Jmdj-ryTsrxyqz5rJI-SDi8cGxTm_PA/17950726964_e00d532716_k.jpg')",
      backgroundSize: :cover,
      zIndex: 100
    }) do
      Mui::Paper(elevation: 3, style: {margin: 20, padding: 20}) { 'one moment while we update our software' }
    end
  end
end
