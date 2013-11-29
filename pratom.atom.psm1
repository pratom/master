$error.clear();
Set-StrictMode -Version:Latest
$GLOBAL:ErrorActionPreference               = "Stop"
# . "$PSCommandPath.vars.ps1"
."$PSCommandPath.vars.ps1"

."$($SCRIPT:DIRECTORY_PATH_OF_pratom_ATOM)\intro_screen.ps1"
import-module -force -DisableNameChecking "$SCRIPT:DIRECTORY_PATH_OF_pratom_ATOM_NUCLEUS\nucleus.psm1"
import-module -force -DisableNameChecking "$SCRIPT:DIRECTORY_PATH_OF_pratom_ATOM_ELECTRONS\electrons.psm1"

Export-ModuleMember -Function *