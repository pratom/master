Function powershell_exe_file_location
{
    [cmdletbinding()] Param ()

    [string]$psPath = join-path where_is_powershell_running_from "powershell.exe" 
    return $psPath
}