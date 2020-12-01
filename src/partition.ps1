using namespace System.Linq

# partition (number theory and combinatorics)

# recursive (less memory usage)
function partition_r([UInt16]$n, [UInt16]$x = 1) {
  end {
    $n
    $(for ($i = $x; $i -le ($n / 2); $i++) {
      foreach ($p in (partition_r ($n - $i) $i)) {
        -join[Enumerable]::Reverse([Object[]](,$i + $p))
      }
    }) | Sort-Object -Descending
  }
}

# back order
function partition_b([UInt16]$n) {
  end {
    [UInt16[]]$a = ,1 * $n
    -join$a
    while ($a.Length -gt 1) {
      $i, $j = ($a.Length - 1), $a[-1]
      $a = [ArraySegment[UInt16]]::new($a, 0, $i)
      while (--$i -and $a[$i - 1] -eq $a[$i]) {
        $j += $a[-1]
        $a = [ArraySegment[UInt16]]::new($a, 0, $i)
      }
      ++$a[$i]
      --$j
      $a = $a + (,1 * $j)
      -join $a
    }
  }
}
