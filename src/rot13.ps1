function rot13([String]$s) {
  end {
    -join[Char[]](0,64,78,90,65,77,91,96,110,122,97,109,123,255 |
      Group-Object {[Math]::Floor($script:i++ / 2)}).ForEach{
        $_.Group[0]..$_.Group[1]}[[Char[]]$s]
  }
}
