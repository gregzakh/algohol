function word_occurrence([String]$s) {
  end {
    $s -replace '-', ' ' -replace '\p{P}' -split '\s+' |
    Group-Object -NoElement
  }
}

<# testing
word_occurrence 'a two-way avenue'
word_occurrence 'This is... this is   the test string.'
#>
