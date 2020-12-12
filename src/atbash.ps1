function atbash {
  param(
    [Parameter(Mandatory, ValueFromPipeline)]
    [ValidateNotNullOrEmpty()]
    [String]$s
  )

  end {
    -join[Char[]](0,64,90,65,91,96,122,97,123,255 |
      Group-Object {[Math]::Floor($script:i++ / 2)}
        ).ForEach{$_.Group[0]..$_.Group[1]}[[Char[]]$s]
  }
}
