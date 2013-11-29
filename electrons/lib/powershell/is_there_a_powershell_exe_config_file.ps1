Function is_there_a_powershell_exe_config_file
{
    [cmdletbinding()] Param ()

    return ( Test-Path powershell_exe_file_location )
}