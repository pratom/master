    #NOTE: To set verbose on import-module, see pr_verbose_import_module in the file, load_a_file_into_rails   
    $GLOBAL:DebugPreference                     = "SilentlyContinue"    
    $GLOBAL:VerbosePreference                   = "SilentlyContinue"    # SilentlyContinue or Continue... NEVER STOP, Inquire, Ignore
    $GLOBAL:WarningPreference                   = "Continue"
    $GLOBAL:ProgressPreference                  = "SilentlyContinue"    # Displays the progress bar and continues with (Default)           execution.
    $GLOBAL:ConfirmPreference                   = "None"                # Windows PowerShell does not prompt automatically. To request confirmation of a particular command, use the Confirm parameter of the cmdlet or function.$DebugPreference                     SilentlyContinue
    $GLOBAL:ErrorActionPreference               = "Stop"                #Displays the debug message and stops executing. Writes an error to the console.
    $GLOBAL:ErrorView                           = "NormalView"          # A detailed view designed for most users. Consists of a description of the error, thename of the object involved in the error,and arrows (<<<<) that point to the wordsin the command that caused the error.

    $GLOBAL:WhatIfPreference                    = 0
    $GLOBAL:FormatEnumerationLimit              = 100

    <# The Log*Event preference variables determine which types of events
        are written to the Windows PowerShell event log in Event Viewer. By
        default, only engine and provider events are logged, but you can use
        the Log*Event preference variables to customize your log, such as 
        logging events about commands. #>
    $GLOBAL:LogCommandHealthEvent               = $True      # Logs errors and exceptions in command initialization and processing. Default = $false (not logged).
    $GLOBAL:LogCommandLifecycleEvent            = $false     # Logs the starting and stopping of commands and command pipelines and security exceptions in command discovery. Default = $false (not logged).
    $GLOBAL:LogEngineHealthEvent                = $True      # Logs errors and failures of sessions. Default = $true (logged).
    $GLOBAL:LogEngineLifecycleEvent             = $true      # Logs the opening and closing of sessions. Default = $true (logged).
    $GLOBAL:LogProviderLifecycleEvent           = $true      # Logs adding and removing of Windows PowerShell providers. Default = $true (logged). (For information about Windows PowerShell providers, type: "get-help about_provider".
    $GLOBAL:LogProviderHealthEvent              = $True      # Logs provider errors, such as read and write errors, lookup errors, and invocation errors. Default = $true (logged).           
    $GLOBAL:PSModuleAutoLoadingPreference       = "None"       # Automatic importing of modules is disabled in the session. To import a module, use the Import-Module cmdlet.  




# http://technet.microsoft.com/en-us/library/hh847796.aspx

# TODO: get-help about_provider
# TODO: about_Parameters_Default_Values.
# TODO: $PSDefaultParameterValues            (None - empty hash table)  
# TODO: $PSEmailServer   
    <#
    # stuff I don't care about and we shouldn't mess with....
    $MaximumAliasCount                   4096
    $MaximumDriveCount                   4096
    $MaximumErrorCount                   256
    $MaximumFunctionCount                4096
    $MaximumHistoryCount                 4096
    $MaximumVariableCount                4096
    $OFS                                 (Space character (" "))
    $OutputEncoding                      ASCIIEncoding object    
    $PSSessionApplicationName            WSMAN
    $PSSessionConfigurationName          http://schemas.microsoft.com/PowerShell/microsoft.PowerShell 
    $PSSessionOption                     (See below) <#Establishes the default values for advanced user options in a
                                                        remote session. These option preferences override the system
                                                            default values for session options. #>    
    #>