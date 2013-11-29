$error.clear();
Set-StrictMode -Version:Latest
$GLOBAL:ErrorActionPreference               = "Stop"
."$PSCommandPath.vars.ps1"

try 
{
    Write-Verbose "BEGIN : PROTONS : TRY"    
    ."$($SCRIPT:DIRECTORY_PATH_OF_pratom_ATOM_NUCLEUS_PROTONS)\assertions\assert_caller_is_in_my_file.ps1"
    ."$($SCRIPT:DIRECTORY_PATH_OF_pratom_ATOM_NUCLEUS_PROTONS)\assertions\assert_caller_is_in_my_directory.ps1"
    ."$($SCRIPT:DIRECTORY_PATH_OF_pratom_ATOM_NUCLEUS_PROTONS)\pr_settings.ps1"
    ."$($SCRIPT:DIRECTORY_PATH_OF_pratom_ATOM_NUCLEUS_PROTONS)\pr_is_debug.ps1"
    ."$($SCRIPT:DIRECTORY_PATH_OF_pratom_ATOM_NUCLEUS_PROTONS)\pr_is_verbose.ps1"
    ."$($SCRIPT:DIRECTORY_PATH_OF_pratom_ATOM_NUCLEUS_PROTONS)\extend_datatype\extend_datatype.ps1"
    ."$($SCRIPT:DIRECTORY_PATH_OF_pratom_ATOM_NUCLEUS_PROTONS)\pr_enum.ps1"
    ."$($SCRIPT:DIRECTORY_PATH_OF_pratom_ATOM_NUCLEUS_PROTONS)\pr_constant.ps1"
    ."$($SCRIPT:DIRECTORY_PATH_OF_pratom_ATOM_NUCLEUS_PROTONS)\RAILS_ENV.ps1"
    import-module -force -DisableNameChecking "$($SCRIPT:DIRECTORY_PATH_OF_pratom_ATOM_NUCLEUS_PROTONS)\file_system\file_system.psm1"
    ."$($SCRIPT:DIRECTORY_PATH_OF_pratom_ATOM_NUCLEUS_PROTONS)\PSClass.ps1"
    import-module -force -DisableNameChecking "$($SCRIPT:DIRECTORY_PATH_OF_pratom_ATOM_NUCLEUS_PROTONS)\ooooops\ooooops.psm1"
    ."$($SCRIPT:DIRECTORY_PATH_OF_pratom_ATOM_NUCLEUS_PROTONS)\loading\loading.ps1"
    what_is_loaded_from_rails
    Export-ModuleMember -Function * 
    Write-Verbose "END : PROTONS : TRY"  
}
finally
{
    Write-Verbose "END : PROTONS : FINALLY"
}