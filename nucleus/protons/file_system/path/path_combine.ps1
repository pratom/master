<#
.SYNOPSIS
    combines paths, and UNLIKE Join-Path, does NOT require the root to exist
.EXAMPLE
    # Drive F does NOT exist on machine.
    path_combine ('f:\', 'r', '2', 'd', '2')
    f:\r\2\d\2
.EXAMPLE
    $program_files_path = [System.Environment]::ExpandEnvironmentVariables("%ProgramFiles%")
    path_combine ($program_files_path, 'r', '2', 'd', '2')
    C:\Program Files\r\2\d\2
.EXAMPLE
    path_combine ($program_files_path, 'r')
    C:\Program Files\r   
.EXAMPLE
    path_combine ($program_files_path, 'r\2\d\')
    C:\Program Files\r\2\d\2
.EXAMPLE
    path_combine ($program_files_path, "\r\2\d\")
.EXAMPLE
    path_combine ($program_files_path, "\Common Files\Modules\")
    C:\Program Files\r\2\d\2

#> 
Function path_combine
{
    [cmdletbinding()]  
    Param (  
       [Parameter(Mandatory=$True)]    [array] $parts_to_join
    )
    [string] $ret_path = ""
    $parts_to_join | ForEach {
        $ret_path = [io.path]::Combine( $ret_path  , $_ )
    }
    return $ret_path   
}
