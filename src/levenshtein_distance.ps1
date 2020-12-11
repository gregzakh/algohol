function levenshtein_distance([String]$s1, [String]$s2) {
  end {
    $m = [Object[][]]::new($s2.Length + 1, $s1.Length + 1)
    for ($i = 0; $i -le $s1.Length; $i++) { $m[0][$i] = $i }
    for ($i = 0; $i -le $s2.Length; $i++) { $m[$i][0] = $i }
    for ($j = 1; $j -le $s2.Length; $j++) {
      for ($i = 1; $i -le $s1.Length; $i++) {
        $d = $s1[$i - 1] -eq $s2[$j - 1] ? 0 : 1
        $m[$j][$i] = [Math]::Min(
          [Math]::Min(
            $m[$j][$i - 1] + 1, $m[$j - 1][$i] + 1
          ), $m[$j - 1][$i - 1] + $d
        )
      }
    }
    $m[$s2.Length][$s1.Length]
  }
}
