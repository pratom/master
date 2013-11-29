# Write-Warning [-Message] <string> [<CommonParameters>]
Function Write-Warning 
{
    [cmdletbinding()] Param ( [Parameter(Mandatory=$false)][string] $Message )  
    try {
        $var = (Snif-WriteVerb -the_write_verbs_bound_parameters:$PSBoundParameters  -write_noun:"WARNING" )   
    }
    catch [Exception]{
        Microsoft.PowerShell.Utility\Write-Warning "ERROR in sniffing verb.  [$($_.Exception.Message)] [$($_.InvocationInfo.PositionMessage)] [$($_.Exception.StackTrace)]"
    }
    return ( Microsoft.PowerShell.Utility\Write-Warning -Message:$Message )
}