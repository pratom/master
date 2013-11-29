<#
.SYNOPSIS
        Returns $true or $false
#>
Function is_powershell_1_being_used
{
    [cmdletbinding()]
    Param (
        )
    if ( $PSVersionTable -eq $null )
    {
        return $true
    }
    else {
        return $false
    }
}