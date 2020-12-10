function xor8([String]$s) {
  end {
    [Byte]$res = 0
    ([Byte[]][Char[]]$s).ForEach{
      $res = ($res + $_) -band 0xFF
    }
    (($res -bxor 0xFF) + 1) -band 0xFF
  }
}
