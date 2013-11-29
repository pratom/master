Function assert_caller_is_in_my_directory
{
    $caller = $MyInvocation
    $callers_command_path = $caller.PSCommandPath
    $callers_directory = $caller.PSScriptRoot

    $callers_caller = ((Get-PSCallStack)[1].InvocationInfo)
    $callers_caller_command_path = $callers_caller.PSCommandPath
    $callers_caller_directory = $callers_caller.PSScriptRoot

    if ($callers_directory -ne $callers_caller_directory) 
        { 
            throw "Only functions within this directory may call this function.  I am in this file=[$callers_command_path] and you are in this file=[$callers_callers_command_path]." 
        } 
}