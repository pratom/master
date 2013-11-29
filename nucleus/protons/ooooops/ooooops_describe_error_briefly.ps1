<#

DONE_TODO: create an object, pass around in descriptions, instead of the string.  add to the object the overall message.  Add to the object as per the property.  So, if message, add to object's message, if stacktrace, add to the object's stack trace, if etc, etc.

TODO: Exception                       =[Data              =[System.Collections.ListDictionaryInternal]

#>



<#
.EXAMPLE
    $ErrorActionPreference="SilentlyContinue"
    1/0
    $desc = (ooooops_describe_error -obj:$error[0])
    write-host $desc
.EXAMPLE
    $ErrorActionPreference="Stop"
    try
    {
        1/0
    }
    catch
    {
        $desc = (ooooops_describe_error -obj:$_)
        write-host $desc
    }
#>
Function ooooops_describe_error ( $obj )
{
    $type = ""
    $obj | Get-Member | ForEach-Object{
        $type =( $_.TypeName )
    }
    $ret_msg = ""
    switch ( $type )
    {
        "System.Management.Automation.ParseException"                       { $ret_msg = (ooooops_describe_error_briefly -parse_exception_to_read:$obj  )}
        "System.Management.Automation.CmdletInvocationException"            { $ret_msg = (ooooops_describe_error_briefly -cmdlet_invocation_exception_to_read:$obj  )}
        "System.Management.Automation.ErrorRecord"                          { $ret_msg = ( ooooops_describe_error_briefly -errorRecord_to_read:$obj  )}
        "System.Management.Automation.ActionPreferenceStopException"        { $ret_msg = (ooooops_describe_error_briefly -action_preference_stop_exception_to_read:$obj  )}
        "System.Management.Automation.ParameterBindingException"            { $ret_msg = (ooooops_describe_error_briefly -parameter_binding_exception_to_read:$obj  )}
        default                                                             { $ret_msg = (ooooops_describe_error_briefly -object:$obj )}
    }
    return $ret_msg
}



Function ooooops_describe_error_briefly
{
    [cmdletbinding()] Param (
            
             [Parameter(ParameterSetName='ParseException', Position=0, Mandatory = $true)]                  [System.Management.Automation.ParseException]                      $parse_exception_to_read
            ,[Parameter(ParameterSetName='CmdletInvocationException', Position=0, Mandatory = $true)]       [System.Management.Automation.CmdletInvocationException]           $cmdlet_invocation_exception_to_read
            ,[Parameter(ParameterSetName='ErrorRecord', Position=0, Mandatory = $true)]                     [System.Management.Automation.ErrorRecord]                         $errorRecord_to_read                 
            ,[Parameter(ParameterSetName='ActionPreferenceStopException', Position=0, Mandatory = $true)]   [System.Management.Automation.ActionPreferenceStopException]       $action_preference_stop_exception_to_read
            ,[Parameter(ParameterSetName='ParameterBindingException', Position=0, Mandatory = $true)]       [System.Management.Automation.ParameterBindingException]           $parameter_binding_exception_to_read
            ,[Parameter(ParameterSetName='Other', Position=0, Mandatory = $true)]                           [Object]                                                           $object

        )
        [string]$parameter_set_name = $PsCmdlet.ParameterSetName
        [string] $desc= ""
        <# Define blank values ------------------ #>
        $error_record   = $null
        $exception      = $null
        $tr             = $null
        <# Define blank values ------------------ #>
    $ErrorActionPreference:Continue
    try 
    {
              
        $format_err = New-Module {            
                        import-module "$PSScriptRoot\ooooops_summ.psm1" -force -noclobber   
                        Export-ModuleMember -Variable * -Function *                
                    } -asCustomObject            
               
        $format_err.level_begin("describe_error_briefly")

        
        switch ($parameter_set_name) 

        { 
            "ParseException"
                {   
                    $tr                     = $parse_exception_to_read
                    $error_record           = $tr.ErrorRecord 
                    $exception              = $tr
                    $format_err = ( desc_parse_error_array $tr.Errors $format_err)
                } 
            "ActionPreferenceStopException"  
                {   
                    $tr                     = $action_preference_stop_exception_to_read
                    $error_record           = $tr.ErrorRecord
                    $exception              = $tr
                } 

            "CmdletInvocationException"  
                {  
                    $tr                     = $cmdlet_invocation_exception_to_read
                    $exception              =  $tr
                } 

            "ParameterBindingException"  
                {  
                    $tr                     = parameter_binding_exception_to_read
                    $exception              = $tr
                    $format_err = ( describe_parameter_binding_exception $tr $format_err)
                } 

            "ErrorRecord"  
                { 
                    $tr = $errorRecord_to_read
                    $error_record = $tr
                } 
            "Other" 
                {
                    $tr = $object
                }  
            Default 
                {
                    return "The function, ooooops_describe_error_briefly, will not attempt to describe anything as the the parameter set passed to it is unknown to it.$($nl)$($nl)"   
                }            
        } 


        $format_err = (describe_exception $exception $format_err)
        $format_err = (describe_run_time_exception $tr  $format_err)
        $format_err = (describe_error_record $error_record  $format_err)
        $format_err.level_end("describe_error_briefly")

        $desc = $format_err.get_compiled_description()
        write-debug "ooooops_describe_error_briefly was asked to an error object thingee of some sort.  Here is what it said:$($nl)$desc"
        return $desc
    }
    catch 
    {  
        try {
          [string]$internal_err = $_.Exception.Message
        }
        catch {

        }
        $err_msg = "The function, ooooops_describe_error_briefly, itself threw an exception, while attempting to describe the exception information sent to it. ITS Exception information=[$internal_err]"
        write-debug "ERROR ERROR ERROR $($err_msg)"
        return  $err_msg   
    }
    
}



Function describe_run_time_exception ($run_time_exception, $format_err)
{
    $format_err.level_begin("run_time_exception")
    if ( $run_time_exception -eq $null ) 
        { 
            $format_err.add("run_time_exception","NULL")
        }
    else 
        {
            if ( ( has_member $run_time_exception "WasThrownFromThrowStatement" ) -eq $false ) 
                { 
                    $format_err.add("is a runtime exception?","NO")    
                } 
            else 
                {
                    $format_err.add("is a runtime exception?","This exception occurred after the script compiled, while a script command was running." )
                    $format_err.add("WasThrownFromThrowStatement", ($run_time_exception.WasThrownFromThrowStatement))
                }  
        }
    $format_err.level_end("run_time_exception")
    return $format_err       
}

Function describe_exception ( $exception , $format_err)
{
    $format_err.level_begin("exception")
    if ( $exception -eq $null )  
        { 
            $format_err.add("exception","NULL")
        }
    else 
        {
            $format_err.add("Data"              ,($exception.Data) )
            $format_err.add("Message"           ,($exception.Message))
            $format_err.add("Source"            ,($exception.Source))
            $format_err.add("StackTrace"        ,($exception.StackTrace))
            $format_err.add("TargetSite"        ,($exception.TargetSite))
            $format_err = ( describe_exception ($exception.InnerException) $format_err )   
        }

    $format_err.level_end("exception" )

    return $format_err
}
Function describe_error_record ($error_record, $format_err)
{
    $format_err.level_begin("error_record")
    if ( $error_record -eq $null )  
        { 
            $format_err.add("error_record" ,"NULL")
        }
    else 
        {
            $format_err.add("CategoryInfo"              ,($error_record.CategoryInfo) )
            $format_err.add("ErrorDetails"              ,($error_record.ErrorDetails) )
            $format_err.add("FullyQualifiedErrorId"     ,($error_record.FullyQualifiedErrorId) )
            $format_err.add("ScriptStackTrace"          ,($error_record.ScriptStackTrace) )
            $format_err.add("TargetObject"              ,($error_record.TargetObject) )         
            $format_err = (describe_exception $error_record.Exception $format_err)           
            $format_err = (describe_invocation_info $error_record.InvocationInfo $format_err)
        }
    $format_err.level_end("error_record"  ) 
    return $format_err
}

Function describe_parameter_binding_exception ($parameter_binding_exception, $format_err)
{
    $format_err.level_begin("parameter_binding_exception")
    if ( $parameter_binding_exception -eq $null )  
        { 
            $format_err.add("parameter_binding_exception" ,"NULL")
        }
    else 
        {
            $format_err.add("CommandInvocation" ,($parameter_binding_exception.CommandInvocation)) 
            $name = $parameter_binding_exception.ParameterName
            $type = $parameter_binding_exception.ParameterType
            $type_actual = $parameter_binding_exception.TypeSpecified
            $format_err.add("ParameterName" ,($name))
            $format_err.add("ParameterType" ,($type))
            $format_err.add("TypeSpecified" ,($type_actual))
            $format_err.add("parameter_binding_descriptive", "The Parameter, [$name], expected a value of type=[$type], but instead received a value of type=[$type_actual].")
            $format_err.add("", ("Calline Line #=[$($parameter_binding_exception.Line)].  Starting at column=$($parameter_binding_exception.Offset)]"))
        }

    $format_err.level_end("parameter_binding_exception" )  
    return $format_err 
}


Function describe_invocation_info ($invocation_info, $format_err)
{
    $format_err.level_begin("invocation_info"  )    
    if ( $invocation_info -eq $null )  
        { 
            $format_err.add("invocation_info" ,"NULL")
        }
    else 
        {
            $format_err.add("PositionMessage" ,($invocation_info.PositionMessage) )
        }   
    $format_err.level_end("invocation_info" )  
    return $format_err
}

Function desc_parse_error_array ( $parse_error_array , $format_err)
{
    $format_err.level_begin("parse_error_array")   
    if ( $parse_error_array -eq $null ) 
        { 
            return "NULL"
        }
    else 
        {
            foreach ($err in $parse_error_array){
                $format_err.level_begin("parse_error")
                $format_err.add("Message"               , ($err.Message)  )
                $format_err = ( desc_iscript_extent $err.Extent $format_err )
                $format_err.level_end("parse_error")
            } 
        }     
    $format_err.level_end("parse_error_array" )
    return $format_err
}

Function desc_iscript_extent ($iscript_extent, $format_err)
{
    $format_err.level_begin("iscript_extent")
    if ( $iscript_extent -eq $null )  
        { 
            $format_err.add("desc_iscript_extent" ,"NULL")
        }
    else 
        {
            $format_err.add("File", ($iscript_extent.File)  )
            $format_err.add("StartLineNumber" ,($iscript_extent.StartLineNumber))
            $format_err.add("StartColumnNumber" ,($iscript_extent.StartColumnNumber))
            $format_err.add("Text" ,($iscript_extent.Text))
        }
    $format_err.level_end("iscript_extent")           
    return $format_err                    
}


Function has_member ( $obj, $member_name )
{
    if ($obj -eq $null ) { return $false }
    $exists = ($obj | Get-Member | Where-Object { $_.Name -eq $member_name.ToString() } | Select { $_.Name } )  
    if ($exists -ne $null)
    {
        return $true
    } 
    else {
        return $false
    }
}


Function member_return_value_safely ( $obj, $member_name)
{
    if ( has_member $obj "ErrorRecord" )
        { 
            return ( Invoke-Expression "`$obj.ErrorRecord") 
        }
    else 
        {
            return $null
        }
}