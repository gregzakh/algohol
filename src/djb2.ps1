#requires -version 7
function djb2([String]$s) {
  end {
    [UInt64]$res = 5381
    for ($i = 0; $i -lt $s.Length; $i++) {
      $res = ($res -shl 5) + $res + [Byte]$s[$i]
    }
    $res
  }
}
