Function get_child_directories
{
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory=$true)][string] $directory_full_path
        )
    if (( path_is_to_directory -to_check:$directory_full_path ) -eq $false ) { throw "Parameter, `$directory_full_path must be a directory.  Value=[$directory_full_path]."}


    write-debug "Get-ChildItem -Directory '$directory_full_path\'"
    $ret_files = ( Get-ChildItem -Directory "$directory_full_path\" | Where-Object{($_.PSIsContainer -eq $true)} | foreach-object{$_.FullName} )
    return $ret_files
}