using namespace System.Windows.Media

Add-Type -AssemblyName WindowsBase

function fib_matrix([UInt16]$n) {
  end {
    $m1, $m2 = [Matrix]::new(1,0,0,1,0,0), [Matrix]::new(1,1,1,0,0,0)
    for ($i = 1; $i -lt $n; $i++) { $m1 *= $m2 }
    $m1.M11
  }
}

function fib_iter([UInt16]$n) {
  end {
    $res = 0, 1
    while (--$n) {
      $res += $res[-1] + $res[-2]
      $res = $res[1, 2]
    }
    $res[-1]
  }
}
