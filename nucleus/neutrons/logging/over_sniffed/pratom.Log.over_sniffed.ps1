Function over_sniffed
{
    [CmdletBinding()]
    Param   (
                [Parameter(Mandatory=$true)][object]        $the_write_verbs_bound_parameters
                , [Parameter(Mandatory=$true)][string]      $write_noun
            )
    try 
    {
        Set-StrictMode -Version:Latest
        [string]$to_write_for_all_log   = ""
        [string]$to_write_for_host_log  = ""

        if ( $the_write_verbs_bound_parameters -eq $null )
            {
                $to_write_for_all_log = "`$the_write_verbs_bound_parameters came in as NULL."
                $to_write_for_host_log = $to_write_for_all_log
            }
        else
            {
                $to_write_for_all_log           = ( get_sniff_log_line -sniff_host_log:$false    -write_noun:$write_noun     -the_write_verbs_bound_parameters:$the_write_verbs_bound_parameters     )
                if ( $write_noun -eq 'HOST' )
                    { 
                        $to_write_for_host_log  = ( get_sniff_log_line -sniff_host_log:$true     -write_noun:$write_noun     -the_write_verbs_bound_parameters:$the_write_verbs_bound_parameters     )
                    }
            }
        $null = ( write_to_sniff_log -write_noun:$write_noun -to_write_for_all_log:$to_write_for_all_log -to_write_for_host_log:$to_write_for_host_log )
    }
    catch [Exception]{
        $msg = "ERROR in sniffing verb in the method, over_sniffed.$($nl)"
        $msg += ( ooooops_describe_error_briefly -errorRecord_to_read:$_ )
        $msg += ( ooooops_describe_global_error_variable )  
        Write-Safe-Warning $msg
        throw $msg 
    }
    return $null
}

Function write_to_sniff_log 
{
    [CmdletBinding()]
    Param   (
                 [Parameter(Mandatory=$true)][string]       $write_noun       
                , [Parameter(Mandatory=$false)][string]      $to_write_for_all_log      # have to allow for empty strings
                , [Parameter(Mandatory=$false)][string]      $to_write_for_host_log     # have to allow for empty strings
            ) 
    assert_caller_is_in_my_file
    if ( $write_noun -eq $null ) { $write_noun = "NULL" }
    $null = ( pratom.Log -log_category:$write_noun -to_log:$to_write_for_all_log -log_file_path:(pratom_PATH_LOG_FILE_SNIFFER_WRITES) )
    if ( $write_noun -eq 'HOST' )
    {            
        $null = ( pratom.Log -log_category:$write_noun -to_log:$to_write_for_host_log -log_file_path:(pratom_PATH_LOG_FILE_SNIFFER_WRITE_HOST) )
    }  
    return $null
}
