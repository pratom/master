Function get_child_files
{
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory=$true)][string] $directory_full_path
        ,[Parameter(Mandatory=$false)][string] $pattern_include = "*.*"
        )
    if (( path_is_to_directory -to_check:$directory_full_path ) -eq $false ) { throw "Parameter, `$directory_full_path must be a directory.  Value=[$directory_full_path]."}

    [string]$to_get_child="Get-ChildItem -File -Path:'$directory_full_path\$pattern_include'"
    Write-Debug $to_get_child

    $ret_files = @()
    Get-ChildItem -File -Path:"$directory_full_path\$pattern_include" | Where-Object{($_.PSIsContainer -eq $false)} | foreach-object{$ret_files+=$_.FullName} 
    return $ret_files
}