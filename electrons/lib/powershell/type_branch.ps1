Function type_branch ( $var, $accumulated_key )
{
    if ( $var -eq $null ) { return "" }
    [string]$ret_string = ""
    $type = $var.GetType().Name
    switch  ( $type  )
    {
        "HashTable" { $ret_string += (hashtable_to_string -var:$var -accumulated_key:$accumulated_key) }
        "Object[]" { $ret_string += (array_to_string -var:$var -accumulated_key:$accumulated_key) }
        default {
            $ret_string += "[$accumulated_key] = [$var]"
        }
    }
    return $ret_string
}