Function get_sniff_log_line
{
    [CmdletBinding()]
    Param   (
                [Parameter(Mandatory=$true)]        [string]    $write_noun
                , [Parameter(Mandatory=$true)]      [bool]      $sniff_host_log
                , [Parameter(Mandatory=$true)]      [object]    $the_write_verbs_bound_parameters
            ) 
    $parameters = ( get_parameters_hash -sniff_host_log:$sniff_host_log -write_noun:$write_noun -the_write_verbs_bound_parameters:$the_write_verbs_bound_parameters )
    [string]$to_write  = (build_sniff_log_line -write_noun:$write_noun  -the_write_verbs_bound_parameters:$parameters  )
    return $to_write
}


Function build_sniff_log_line
{
    [CmdletBinding()]
    Param   (
                  [Parameter(Mandatory=$true)][string]      $write_noun      
                , [Parameter(Mandatory=$true)][object]      $the_write_verbs_bound_parameters
            ) 
    assert_caller_is_in_my_directory
    $parameter_count = 0
    [string]$parameters_string = ""
    foreach ($entry in $the_write_verbs_bound_parameters){
        $parameter_count += 1
        $parameters_string += ( PRSP -entry:$entry -parameter_count:$parameter_count )
    }

    [string]$sniffed_tag_open               = ( value_pad_right -column_name:"SNIFFED_tag_open" -value:(SNIFFED_TAG_OPEN) )
    [string]$parameters_string_indented     = ( value_new_lines_indented -column_name_of_previous_column:"SNIFFED_tag_open" -value:$parameters_string ) 
    [string]$line                           = ( "$($sniffed_tag_open)|$($parameters_string_indented)</SNIFFED>" )  
    return $line  
}


Function get_parameters_hash
{
    [CmdletBinding()]
    Param   (
                [Parameter(Mandatory=$true)]        [string]    $write_noun
                , [Parameter(Mandatory=$false)]     [switch]    $sniff_host_log
                , [Parameter(Mandatory=$true)]      [object]    $the_write_verbs_bound_parameters
            ) 
    assert_caller_is_in_my_file
    $parameters = ( $the_write_verbs_bound_parameters.GetEnumerator() )
    if ( $sniff_host_log -and ( $write_noun -eq 'HOST' ) )
    {
        $parameters = (  $the_write_verbs_bound_parameters.GetEnumerator() | Where-Object { $_.Key -eq "Object" } )
    }
    return $parameters
}