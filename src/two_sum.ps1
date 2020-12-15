function two_sum([UInt32[]]$arr, [UInt32]$sum) {
  end {
    for ($i, $r = 0, @{}; $i -lt $arr.Length; $i++) {
      if ($r.ContainsKey(($d = $sum - $arr[$i]))) {
        return "[$($r[$d]), $i]"
      }
      else { $r[$arr[$i]] = $i }
    }
    $false
  }
}

<# testing
two_sum (0, 2, 11, 19, 20) 21
#>
