$error.clear();
Set-StrictMode -Version:Latest
$GLOBAL:ErrorActionPreference               = "Stop"
# . "$PSCommandPath.vars.ps1"
."$PSCommandPath.vars.ps1"





try 
{
  Write-Verbose "BEGIN : $PSCommandPath."
  $loaded = (import-module "$("$SCRIPT:DIRECTORY_PATH_OF_pratom_ATOM_NUCLEUS_PROTONS\protons.psm1")" -force -DisableNameChecking )
  set-alias pr_include Invoke-Expression
  pr_include (code_to_load_a_directory "$($SCRIPT:DIRECTORY_PATH_OF_pratom_ATOM_ELECTRONS)\lib\")
  pr_include (code_to_load_a_directory "$($SCRIPT:DIRECTORY_PATH_OF_pratom_ATOM_ELECTRONS)\make\")  
  pr_include (code_to_load_a_directory "$($SCRIPT:DIRECTORY_PATH_OF_pratom_ATOM_ELECTRONS)\vendor\")
  what_is_loaded_from_rails
  pr_import_module_status_show "END OF TRY BLOCK $PSCommandPath"
}
finally
{
  Write-Verbose "END : $PSCommandPath.
  If Functions were exported, you will see them being Imported to your scope now."   
}


<# 
.EXAMPLE
    Function play_with_errors
    {
        [cmdletbinding()]Param ()
        Import-Module ".\ooooops_describe_global_error_variable.ps1" -Force 
        
        try
        {
            throw ".....this is our error message....." 
        }
        catch
        {
            $as_string = ooooops_describe_global_error_variable
            Write-Host $as_string
        }
    }
    $DebugPreference = continue
    Write-Host "before the call to play_with_errors"
    play_with_errors -erroraction Continue
    Write-Host "after the call to play_with_errors"
#>
Function ooooops_describe_global_error_variable
{
    $ErrorActionPreference:Continue
    try 
    {    
        $nl = [Environment]::NewLine
        $div = "$($nl)___________________________________________________________$($nl)"
        $ret_string=""
        $cnt = $Error.Count
        $ret_string += "$($div)There are [$($cnt)] Errors in the global error variable array, `$error.$($div)" 
        $i=0
        while ($i -lt $cnt) {
            $ret_string += "$($div)`$Error[$i] :$($div)$(ooooops_describe_error_briefly -errorRecord_to_read:$Error[$i] )$($div)$($div)$($div)$($div)$($div)"
            $i += 1
            }
        write-debug "ooooops_describe_global_error_variable was asked to describe the global error variable array, `$error.  Here is what it said:$($nl)"
        return $ret_string
    }
    catch 
    {
        $msg = "The function, ooooops_describe_global_error_variable, itself threw an exception, while attempting to describe the exception information sent to it." 
        write-debug "ERROR ERROR ERROR $msg"
        return   $msg 
    }   
}
