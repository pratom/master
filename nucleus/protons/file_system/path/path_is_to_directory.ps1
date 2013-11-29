Function path_is_to_directory
{
    [cmdletbinding()] Param ( [Parameter(Mandatory=$False)][string]$to_check )
    return ( path_is_expected_type -a_path:$to_check -expected_type:System.IO.DirectoryInfo )
}