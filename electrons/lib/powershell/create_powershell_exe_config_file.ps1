Function create_powershell_exe_config_file
{
    # http://thepursuitofalife.com/powershell-and-the-net-4-0-framework/
    [cmdletbinding()] Param ()

    $x = @" 
"@
    [string]$config_file_dir_path = where_path_is_powershell_running_from
    if (-not (test-path $config_file_dir_path)) 
        { 
            (new-item -itemtype file -path $path -name "powershell.exe.config") | out-null 
        }  

    [string]$config_file_full_path = powershell_exe_config_file_location
    $x | out-file -FilePath (resolve-path $config_file_full_path) -Encoding UTF8  

    return $true 
}