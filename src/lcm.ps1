# least common multiple
function gcd($x, $y) {[Math]::Abs((.({gcd $y ($x % $y)}, {$x})[!$y]))}
function lcm($x, $y) {[Math]::Abs($x * $y / (gcd $x $y))}
