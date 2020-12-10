function fac([UInt16]$n) {$n -le 1 ? 1 : $n * (fac ($n - 1))}
