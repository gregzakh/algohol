#requires -version 7
function caeser_cipher {
  param(
    [Parameter(Mandatory, Position=0)]
    [ValidateNotNullOrEmpty()]
    [String]$InputString,

    [Parameter()]
    [ValidateRange(1, 25)]
    [Int32]$Key = 1,

    [Parameter()]
    [Switch]$Decode
  )

  end {
    $mov = $Decode ? ($Key * -1) : $Key
    [Char[]]$abc = 'a'..'z' + 'A'..'Z'
    [Char[]]$arr = $InputString
    -join$(for ($i = 0; $i -lt $arr.Length; $i++) {
      $arr[$i] -in $abc ? $(
        [Char]::"To$([Char]::IsUpper($arr[$i]) ? 'Upp' : 'Low')er"(
          $abc[($abc.IndexOf($arr[$i]) + $mov) % $abc.Length]
        )
      ) : $arr[$i]
    })
  }
}

<# testing block
($res = caeser_cipher -InputString (
  Read-Host 'Test string'
) -Key (Get-Random -Minimum 1 -Maximum 26))
'-' * 9 + ' BRUTE ' + '-' * 9
(1..25).ForEach{
  caeser_cipher -InputString $res -Decode -Key $_
}
#>
