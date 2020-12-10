# palindrome test
# .e.g.: Madam, I'm Adam!
#        Sum summus mus
# and etc.
function palindrome([String]$x) {
  end {
    (-join[Linq.Enumerable]::Reverse(
      ($$ = $x -replace '[^\p{L}]').ToLower()
    )) -eq $$
  }
}
