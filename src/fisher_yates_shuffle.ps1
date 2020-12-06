# Fisher-Yates shuffle
function knuth([Object[]]$a) {Get-Random -InputObject $a -Count $a.Length}
function sattolo([Object[]]$a) {
  end {
    for ($i = 0; $i -lt $a.Length; $i++) {
      $j = Get-Random -Minimum 0 -Maximum $a.Length
      $k = Get-Random -Minimum 0 -Maximum $a.Length
      $a[$j], $a[$k] = $a[$k], $a[$j]
    }
    $a
  }
}
