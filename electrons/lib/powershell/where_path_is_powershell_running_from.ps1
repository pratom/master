<#
.SYNOPSIS
        Where is powershell.exe ?
#>
Function where_path_is_powershell_running_from
{
    [cmdletbinding()] Param ()
    
    return $PsHome
}