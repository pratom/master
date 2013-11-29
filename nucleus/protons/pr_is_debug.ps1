function pr_is_debug
{
    if ( $GLOBAL:DebugPreference -eq "Continue" )
    {
        return $true
    } 
    else {
        return $false
    }
}