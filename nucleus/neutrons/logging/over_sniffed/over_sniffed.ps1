<#
over_sniffed is not just another feature.  It IS the way that consuming code interfaces with pratom logging.

    The philosophy is simple:  There is no reason for a developer to write two lines of code:
        console.write
        log.write

    Instead, logging is accomplished by watching console.write ( or whatever construct this language uses )

#TODO...fix this bug:
what_is_loaded_from_module_named ready_bake | write-host
========ERROR SUMMARY=========================================================================================

Cannot bind argument to parameter 'the_write_verbs_bound_parameters' because it is null.

InvalidData: (:) [get_sniff_log_line], ParameterBindingValidationException

at get_sniff_log_line, C:\projects\pratom\NUCLEUS\NEUTRONS\logging\over_sniffed\get_sniff_log_line.ps1: line 10
at over_sniffed, C:\projects\pratom\NUCLEUS\NEUTRONS\logging\over_sniffed\pratom.Log.over_sniffed.ps1: line 21
at <ScriptBlock>, C:\projects\pratom\NUCLEUS\NEUTRONS\logging\over_sniffed\over_sniffed.ps1: line 18
at Snif-WriteVerb, C:\projects\pratom\NUCLEUS\NEUTRONS\write-commandlets\Snif-WriteVerb.ps1: line 24
at Write-Host, C:\projects\pratom\NUCLEUS\NEUTRONS\write-commandlets\Write-Host.ps1: line 16
at <ScriptBlock>, C:\projects\ready_bake\ready_bake\ready_bake.psm1: line 11
at <ScriptBlock>, <No file>: line 2
at <ScriptBlock>, C:\projects\ready_bake\ready_bake.ps1: line 4
at <ScriptBlock>, <No file>: line 1
   at System.Management.Automation.ParameterBinderBase.ValidateNullOrEmptyArgument(CommandParameterInternal parameter, CompiledCommandParameter parameterMetadata, Type argumentType, Object parameterValue, Boolean recurseIntoCollections)
   at System.Management.Automation.ParameterBinderBase.BindParameter(CommandParameterInternal parameter, CompiledCommandParameter parameterMetadata, ParameterBindingFlags flags)
   at System.Management.Automation.CmdletParameterBinderController.BindParameter(CommandParameterInternal argument, MergedCompiledCommandParameter parameter, ParameterBindingFlags flags)
   at System.Management.Automation.CmdletParameterBinderController.BindParameter(UInt32 parameterSets, CommandParameterInternal argument, MergedCompiledCommandParameter parameter, ParameterBindingFlags flags)
   at System.Management.Automation.CmdletParameterBinderController.BindParameters(UInt32 parameterSets, Collection`1 arguments)
   at System.Management.Automation.CmdletParameterBinderController.BindCommandLineParametersNoValidation(Collection`1 arguments)
   at System.Management.Automation.CmdletParameterBinderController.BindCommandLineParameters(Collection`1 arguments)
   at System.Management.Automation.CommandProcessor.BindCommandLineParameters()
   at System.Management.Automation.CommandProcessorBase.DoPrepare(IDictionary psDefaultParameterValues)
   at System.Management.Automation.Internal.PipelineProcessor.Start(Boolean incomingStream)
   at System.Management.Automation.Internal.PipelineProcessor.SynchronousExecuteEnumerate(Object input, Hashtable errorResults, Boolean enumerate)
At C:\projects\pratom\NUCLEUS\NEUTRONS\logging\over_sniffed\pratom.Log.over_sniffed.ps1:21 char:53
+                 $to_write_for_all_log           = ( get_sniff_log_line -sniff_ho ...
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
==============================================================================================================

#>
pr_include (code_to_load_a_file ("$PSScriptRoot\get_sniff_log_line.ps1"))
pr_include (code_to_load_a_file ("$PSScriptRoot\pratom.Log.over_sniffed.ps1"))
pr_include (code_to_load_a_file ("$PSScriptRoot\pratom.Log.over_sniffed.vars.ps1"))
pr_include (code_to_load_a_file ("$PSScriptRoot\PRSP.ps1"))

$script_block_sniffing={
    if ((Test-Path variable:the_write_verbs_bound_parameters) -eq $true )
        {
            over_sniffed -the_write_verbs_bound_parameters:$the_write_verbs_bound_parameters -write_noun:$write_noun 
        }
}
$SCRIPT:write_sniffer_name_for_removal = (Add-WriteSniffer -your_name:("pratom.Log.over_sniffed.ps1") -your_script_block:$script_block_sniffing)
<#
    At this point, any call to Write-? will call pratom.Log
#>
pratom.Log -log_category:"OVER_SNIFFED" -to_log:"Write Verb Sniffing has been setup.  Sniffing will log to=[$(pratom_PATH_LOG_FILE_SNIFFER_WRITES)]."                                        -log_file_path:(pratom_PATH_LOG_FILE_MAIN)
pratom.Log -log_category:"OVER_SNIFFED" -to_log:"Write Verb Sniffing has been setup.  It will log to this file.  FYI, the main log file=[$(pratom_PATH_LOG_FILE_MAIN)]"                      -log_file_path:(pratom_PATH_LOG_FILE_SNIFFER_WRITES)
pratom.Log -log_category:"OVER_SNIFFED" -to_log:"Write Verb Sniffing has been setup.  WRITE-HOST Sniffing will log to=[$(pratom_PATH_LOG_FILE_SNIFFER_WRITE_HOST)]."                         -log_file_path:(pratom_PATH_LOG_FILE_MAIN)
pratom.Log -log_category:"OVER_SNIFFED" -to_log:"Write Verb Sniffing has been setup.  WRITE-HOST Sniffing will log to this file.  FYI, the main log file=[$(pratom_PATH_LOG_FILE_MAIN)]"     -log_file_path:(pratom_PATH_LOG_FILE_SNIFFER_WRITE_HOST)