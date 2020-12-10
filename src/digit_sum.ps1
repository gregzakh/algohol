# digit sum
# functional
function sum_f([UInt64]$n) {
  end { [Linq.Enumerable]::Sum([Int32[]]($n -split '[^\d]*')) }
}
# iterative
function sum_i([UInt64]$n) {
  end {
    $r = [Int32]($n / [Math]::Pow(10, "$n".Length - 1))
    for ($i = 0; $n -ge $r;) {
      $i, $n = ($i + $n % 10), ($n / 10)
    }
    $i
  }
}
