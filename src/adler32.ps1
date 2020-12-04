#requires -version 7
function adler32([String]$s) {
  end {
    $a, $b = [UInt32[]](1, 0)
    for ($i = 0; $i -lt $s.Length; $i++) {
      $a = ($a + $s[$i]) % 65521
      $b = ($b + $a) % 65521
    }
    ($b -shl 16) -bor $a
  }
}
