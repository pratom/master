<#
import-module .\extend.ps1 -Force
import-module .\datetime.ps1 -Force
(Get-Date).Sortable
20131029-051756499904312
#>


<#
get_sortable_datetime
20131029-051550395944312

get_sortable_datetime -to_format:"1/1/1974"
19740101-060600000000000
#>
Function get_sortable_datetime
{
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory=$False)][datetime]$to_format = (Get-Date)
    )
    [string]$ret_dt_formatted = ""
    $to_format = $to_format.ToUniversalTime()
    [string]$format=get_sortable_format
    $ret_dt_formatted = $to_format.ToString($format)   
    return($ret_dt_formatted)
}

Function get_sortable_date
{
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory=$False)][datetime]$to_format = (Get-Date)
    )
    [string]$ret_dt_formatted = ""
    $to_format = $to_format.ToUniversalTime()
    [string]$format=get_sortable_date_format
    $ret_dt_formatted = $to_format.ToString($format)
    return($ret_dt_formatted)
}


Function get_sortable_format
{
    [cmdletbinding()] Param ()
    [string] $ret_string ="yyyyMMddzzHHmmssfffffff"
    return $ret_string
}

Function get_sortable_date_format
{
    [cmdletbinding()] Param ()
    [string] $ret_string ="yyyyMMddzz"
    return $ret_string
}










<#
.EXAMPLE
    (Get-Date).Sortable
#>
<#
Function PRIVATE:add_member_Sortable
{
    [cmdletbinding()] Param ()
    $script_block = {return(get_sortable_datetime -to_format:$this)}
    extend_datatype_with_method -member_name:Sortable -script_block_get:$script_block -type_name:System.DateTime
}



Function PRIVATE:add_member_Sortable_String_Format
{
    [cmdletbinding()] Param ()
    $script_block = {return(Sortable_String_Format)}
    extend_datatype_with_method -member_name:Sortable_String_Format -script_block_get:$script_block -type_name:System.DateTime
}
add_member_Sortable
add_member_Sortable_String_Format
#>


