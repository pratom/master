Function path_is_to_file
{
    [cmdletbinding()] Param ( [Parameter(Mandatory=$False)][string]$to_check )
    Write-Debug "path_is_to_file `$to_check=[$to_check]"
    return ( path_is_expected_type -a_path:$to_check -expected_type:System.IO.FileInfo )
}