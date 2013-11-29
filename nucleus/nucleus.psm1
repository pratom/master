$error.clear();
Set-StrictMode -Version:Latest
$GLOBAL:ErrorActionPreference               = "Stop"
."$PSCommandPath.vars.ps1"


import-module -force -DisableNameChecking "$($SCRIPT:DIRECTORY_PATH_OF_pratom_ATOM_NUCLEUS_PROTONS)\protons.psm1"
import-module -force -DisableNameChecking "$($SCRIPT:DIRECTORY_PATH_OF_pratom_ATOM_NUCLEUS_NEUTRONS)\neutrons.psm1"

Export-ModuleMember -Function *