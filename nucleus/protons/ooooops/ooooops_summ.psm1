<#
.EXAMPLE
        $format_err = New-Module 
                    {            
                        import-module "$PSScriptRoot\ooooops_summ.psm1" -force -noclobber   
                        Export-ModuleMember -Variable * -Function *                
                    } -asCustomObject            
               
        $format_err.level_begin "exception"
        $format_err.add "property_name" $my_obj.property_name
        $format_err.add "property_name2" $my_obj.property_name2
        $format_err.add "property_name3" $my_obj.property_name3
        $format_err.level_begin "invocation_info"
        $format_err.add "property_name" $my_obj.property_name
        $format_err.add "property_name2" $my_obj.property_name2
        $format_err.add "property_name3" $my_obj.property_name3
        $format_err.add "property_name4" $my_obj.property_name4
        $format_err.level_end "invocation_info"        
        $format_err.add "property_name4" $my_obj.property_name4
        $format_err.level_end "exception"

        write-host ($format_err.get_compiled_description)
#>
Set-StrictMode -Version:Latest

[int]$SCRIPT:ascii_carriage_return_int = 13
[int]$SCRIPT:ascii_line_feed_int = 10
[int]$SCRIPT:ascii_vertical_tab_int = 11

[string]$SCRIPT:ascii_carriage_return_string   = ( [char]$SCRIPT:ascii_carriage_return_int )
[string]$SCRIPT:ascii_line_feed_string         = ( [char]$SCRIPT:ascii_line_feed_int    )
[string]$SCRIPT:ascii_vertical_tab_string      = ( [char]$SCRIPT:ascii_vertical_tab_int )


$SCRIPT:error_desc = ""

[string]$SCRIPT:nl                              = [Environment]::NewLine
$SCRIPT:current_level = 1


Function level_begin($level_name)
{

    $SCRIPT:error_desc             += "$($nl)$(indent)$($nl)$(indent)BEGIN---> $level_name"
    $SCRIPT:current_level += 1      
}


Function level_end($level_name)
{
    $SCRIPT:current_level -= 1
    $SCRIPT:error_desc             += "$($nl)$(indent)END---> $level_name$($nl)$(indent)"
}


Function add ($name, $value)
{
    if ($value -eq $null )  { $value = "VALUE_IS_NULL" }
    $value = $value.ToString()
    if ($value -eq "")      { $value="VALUE_IS_EMPTY_STRING"}

    if ($name -eq $null )  { $name = "NAME_IS_NULL" }
    $name = $name.ToString()
    if ($name -eq "")      { $name="NAME_IS_EMPTY_STRING"}

    switch ($name)
    {
        "CategoryInfo"                      { add_category_info     $value }        
        "Message"                           { add_message           $value }
        "parameter_binding_descriptive"     { add_message           $value }
        "PositionMessage"                   { add_stacktrace        $value }
        "ScriptStackTrace"                  { add_stacktrace        $value }
        "StackTrace"                        { add_stacktrace        $value }
    }
    $value = (scrub_new_lines $value)
    $value = (value_new_lines_indented $value)
    $name = $name.PadRight(30," ")
    $SCRIPT:error_desc             += "$($nl)$(indent)$name       =[$($value)]" 
}


Function get_compiled_description ()
{
    return "
========ERROR SUMMARY=========================================================================================
$(remove_doubles -value:(scrub_new_lines $SCRIPT:message) -double_what:$nl )
$(remove_doubles -value:(scrub_new_lines $SCRIPT:category_info) -double_what:$nl )
$(remove_doubles -value:(scrub_new_lines $SCRIPT:stack_trace) -double_what:$nl )
==============================================================================================================
    $($SCRIPT:error_desc)"
}


   

Function value_new_lines_indented ( $value )
{
    if ( $value -eq $null ) { return "" }
    $val_indent = "$(indent)$(" " * 38)"
    $value = $value.Replace($nl, "$($nl)$($val_indent)|")
    return $value
}


Function scrub_new_lines ( $value )
{
    if ( $value -eq $null ) { return "" }
    if ( $value -eq "" ) { return "" }
    $value = $value.Replace(([string]$SCRIPT:ascii_carriage_return_string)   , "") 
    $value = $value.Replace(([string]$SCRIPT:ascii_vertical_tab_string)      , "")    
    $value = $value.Replace(([string]$SCRIPT:ascii_line_feed_string)         , $nl)
    return $value
}


Function remove_doubles
{
    [cmdletbinding()] Param (
        [Parameter(Mandatory = $false)] [string]    $value
        ,[Parameter(Mandatory = $true)] [string]    $double_what
        )
    [string] $dbl = ($double_what * 2)
    while ( $value.Contains( $dbl ) ){
        $value = $value.Replace($dbl, $double_what)
    }
    return $value
}



Function indent ()
{
    if ( $SCRIPT:current_level -gt 0 )
    {
        return ("     " * $SCRIPT:current_level )
    }
    else 
    {
        return ""
    }
}




$SCRIPT:message = ""
Function add_message ($str)
{
    $SCRIPT:message += "$($nl)$($nl)$str"
}

$SCRIPT:stack_trace = ""
Function add_stacktrace ($obj)
{
    $SCRIPT:stack_trace += "$($nl)$($nl)$obj"
}

$SCRIPT:category_info = ""
Function add_category_info ($obj)
{
    $SCRIPT:category_info += "$($nl)$($nl)$obj"
}