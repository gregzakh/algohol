function gcd($x, $y) {[Math]::Abs((.({gcd $y ($x % $y)}, {$x})[!$y]))}
