function hamming_distance {
  param(
    [Parameter(Mandatory, Position=0)]
    [ValidateNotNullOrEmpty()]
    [String]$s1,

    [Parameter(Mandatory, Position=1)]
    [ValidateNotNullOrEmpty()]
    [String]$s2
  )

  end {
    if ($s1.Length -ne $s2.Length) {
      throw [InvalidOperationException]::new('Should be same length.')
    }

    <#for ($i, $d = 0, 0; $i -lt $s1.Length; $i++) {
      if ($s1[$i] -ne $s2[$i]) { $d++ }
    }
    $d#>

    ($zip = [Linq.Enumerable]::Zip( # seems more pretty
      [Char[]]$s1, [Char[]]$s2, [Func[Char, Char, Char[]]]{$args[0], $args[1]}
    )).Where{$_[0] -ne $_[1]}.Count
    $zip.Dispose()
  }
}
