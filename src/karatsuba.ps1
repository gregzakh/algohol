# multiply two numbers using Karatsuba algorithm

function karatsuba($x, $y) {
  begin {
    function private:divmod($x, $y) {
      end {
        $r = 0
        [Math]::DivRem($x, $y, [ref]$r), $r
      }
    }
  }
  process {}
  end {
    if ($x -lt 10 -or $y -lt 10) {
      return $x * $y
    }

    $m1 = [String[]]($x, $y)
    $m1 = [Math]::Max($m1[0].Length, $m1[1].Length)
    $m2 = [Math]::Floor($m1 / 2)

    $h1, $l1 = divmod $x ([Math]::Pow(10, $m2))
    $h2, $l2 = divmod $y ([Math]::Pow(10, $m2))

    $z0 = karatsuba $l1 $l2
    $z1 = karatsuba ($h1 + $l1) ($h2 + $l2)
    $z2 = karatsuba $h1 $h2

    $z2 * [Math]::Pow(10, $m2 * 2) + (
      $z1 - $z2 - $z0
    ) * [Math]::Pow(10, $m2) + $z0
  }
}
