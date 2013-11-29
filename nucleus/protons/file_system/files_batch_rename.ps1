function files_batch_rename
{
    [cmdletbinding()] Param (
             [Parameter( Mandatory = $true)]        [string]    $path_to_recurse
             , [Parameter( Mandatory = $true)]      [string]    $string_to_find_in_name
             , [Parameter( Mandatory = $true)]      [string]    $string_to_inject_in_name
        )
    Get-ChildItem -LiteralPath:$path_to_recurse -Recurse -File -Filter:"*$($string_to_find_in_name)*" | foreach { $_.MoveTo("$($_.DirectoryName)\$($_.Name.Replace($string_to_find_in_name, $string_to_inject_in_name))") }
}