Function powershell_exe_config_file_location
{
    [cmdletbinding()] Param ()

    [string]$psPath = join-path where_is_powershell_running_from "powershell.exe.config" 
    return $psPath
}