function path_is_expected_type
{
    [cmdletbinding()] Param ( 
          [Parameter(Mandatory=$False)][string]                 $a_path
        , [Parameter(Mandatory=$False)]                         $expected_type
        ) 

    [bool]$ret_is_expected_type = $false
    if (path_is_valid $to_check)
    {
        if ((Test-Path -LiteralPath:$a_path -PathType:Leaf) -or (Test-Path -LiteralPath:$a_path -PathType:Container))
        {
            #path exists
            $actual_type=(path_data_type -a_path:$a_path)
            if ( $actual_type.ToString() -eq $expected_type.ToString() )
            {
               $ret_is_expected_type = $true 
            }
            else {
                Write-Debug "path_is_expected_type path was not of expected type.  path=[$a_path].  expected_type=[$($expected_type.ToString())].  actual_type=[$($actual_type.ToString())]."
            }
        }    
    }
    return $ret_is_expected_type
}

