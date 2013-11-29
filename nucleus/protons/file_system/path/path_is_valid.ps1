Function path_is_valid
{
    [cmdletbinding()] Param ( [Parameter(Mandatory=$False)][string]$to_check = "" )   
    Write-Debug "path_is_valid `$to_check=[$to_check]"
    if ( $to_check -eq "" -or $to_check -eq $null )
    {
      return($false)
    }
    else {
      return ( Test-Path -LiteralPath:$to_check -IsValid )   
    }
}