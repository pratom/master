Function am_i_running_as_admin
{
    [bool] $ret_val = $false
    $Global:Admin=''
    $CurrentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent() 
    $principal = new-object System.Security.principal.windowsprincipal($CurrentUser)
    if ($principal.IsInRole("Administrators")) 
        { 
            ret_val = $true
        }
    
    return $ret_val
}

