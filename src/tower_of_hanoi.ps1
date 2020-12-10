function hanoi {
  param(
    [Parameter(Mandatory, Position=0)][Byte]$n,
    [Parameter(Position=1)][Char]$t1 = 'A',
    [Parameter(Position=2)][Char]$t2 = 'B',
    [Parameter(Position=3)][Char]$t3 = 'C'
  )

  end {
    if ($n -ge 1) {
      hanoi ($n - 1) $t1 $t3 $t2
      'Moving disk from {0} to {1}' -f $t1, $t2
      hanoi ($n - 1) $t3 $t2 $t1
    }
  }
}
