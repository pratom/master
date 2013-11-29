Function get_same_name_file
{
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory=$true)][string] $directory_full_path
        ) 
    assert_caller_is_in_my_directory
    $dir_name = split-path -path:$directory_full_path -Leaf 
    $ps1 = "$directory_full_path\$dir_name.ps1"
    $psm1 = "$directory_full_path\$dir_name.psm1"
    
    if (Test-Path -LiteralPath:$ps1 -PathType:Leaf)
    {
      return $ps1
    }
    if (Test-Path -LiteralPath:$psm1 -PathType:Leaf)
    {
      return $psm1
    }
    return $null
}