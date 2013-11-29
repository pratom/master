Function pratom.Log.Start
{
    [CmdletBinding()]   Param ([Parameter(Mandatory=$true)][string] $log_path_n_name)

    if (((Test-Path -Path $log_path_n_name)) -eq $false ){
        New-Item $log_path_n_name -type:File
        pratom.Log -log_category:"OPEN LOG" -to_log:"The Log, $log_path_n_name, has opened." -log_file_path:$log_path_n_name
        if ( $log_path_n_name -ne (pratom_PATH_LOG_FILE_MAIN) )
        {
            pratom.Log -log_category:"OPEN LOG" -to_log:"The Log, $log_path_n_name, has opened." -log_file_path:$log_path_n_name
        }
    }   
    return $true  
}