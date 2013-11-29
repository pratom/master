Function hashtable_to_string ($var, $accumulated_key)
{
    if ( $var -eq $null ) { return "" }
    [string]$ret_string = ""
    foreach ($item in $var.GetEnumerator()){
        $key = $item.Name
        $accumulated_key = "$accumulated_key.$key"
        $ret_string += "[$accumulated_key]="  
        $ret_string += ( type_branch -var:$value -accumulated_key:$accumulated_key )     
    }
}