Function assert_caller_is_in_my_file
{
    $callers_command_path = $MyInvocation.PSCommandPath
    $callers_callers_command_path = ((Get-PSCallStack)[1].InvocationInfo).PSCommandPath
    if ($callers_command_path -ne $callers_callers_command_path) 
        { 
            throw "Only functions within this file may call this function.  I am in this file=[$callers_command_path] and you are in this file=[$callers_callers_command_path]." 
        } 
}