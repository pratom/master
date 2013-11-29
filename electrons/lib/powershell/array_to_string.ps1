Function array_to_string ($var, $accumulated_key)
{
    if ( $var -eq $null ) { return "" }
    [string]$ret_string = ""
    foreach ( $value in $var ) {
        $ret_string += (type_branch -var:$value -accumulated_key:$accumulated_key)
    } 
    return $ret_string
}