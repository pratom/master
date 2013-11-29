function pr_is_verbose
{
    if ( $GLOBAL:VerbosePreference -eq "Continue" )
    {
        return $true
    } 
    else {
        return $false
    }
}