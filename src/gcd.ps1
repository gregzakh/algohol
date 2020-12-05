# greatest common divisor
# recursive
function gcd_r($x, $y) {[Math]::Abs((.({gcd_r $y ($x % $y)}, {$x})[!$y]))}
# iterative
function gcd_i($x, $y) {while($y){$x, $y = $y, ($x % $y)};[Math]::Abs($x)}
