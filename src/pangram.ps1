function pangram {
  param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [String]$s
  )

  end {
    !(Compare-Object -ReferenceObject (
      [Char[]]($s.ToLower() -replace '\p{P}|\s') |
      Group-Object
    ).Name -DifferenceObject ('a'..'z'))
  }
}
