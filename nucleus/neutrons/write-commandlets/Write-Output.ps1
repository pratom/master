#Write-Output [-InputObject] <psobject[]> [<CommonParameters>]
Function Write-Output 
{
    [cmdletbinding()] Param ( [Parameter(Mandatory=$true)][psobject[]] $InputObject )  
    # Snif-WriteVerb -the_write_verbs_bound_parameters:$PSBoundParameters
    Microsoft.PowerShell.Utility\Write-Output -InputObject:$InputObject
}
