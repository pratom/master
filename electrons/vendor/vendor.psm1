$error.clear();
Set-StrictMode -Version:Latest
$GLOBAL:ErrorActionPreference               = "Stop"
."$PSCommandPath.vars.ps1"



write-debug "BEGIN loading of vendor modules................"
import-module -force -DisableNameChecking "$SCRIPT:DIRECTORY_PATH_OF_pratom_ATOM_NUCLEUS_PROTONS\protons.psm1"
set-alias pr_include Invoke-Expression
pr_include (code_to_load_a_file ("$($SCRIPT:DIRECTORY_PATH_OF_pratom_ATOM_ELECTRONS_VENDOR )\ISE\ISE.ps1") )
pr_include (code_to_load_a_file ("$($SCRIPT:DIRECTORY_PATH_OF_pratom_ATOM_ELECTRONS_VENDOR )\PowerYaml\PowerYaml.psm1") )
# pr_include (code_to_load_a_file ("$($SCRIPT:DIRECTORY_PATH_OF_pratom_ATOM_ELECTRONS_VENDOR )\EZOut\EZOut.psm1") )
# pr_include (code_to_load_a_file ("$($SCRIPT:DIRECTORY_PATH_OF_pratom_ATOM_ELECTRONS_VENDOR )\pester\pester.psm1") )
write-debug "END loading of vendor modules................"