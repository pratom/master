#requires -version 2.0

<#
A collection of add-ons for the Powershell 2.0 ISE
#>

#dot source the scripts
. $psScriptRoot\Test-ISEBuffer.ps1
. $psScriptRoot\New-CommentHelp.ps1
. $psScriptRoot\ConvertTo-TextFile.ps1
. $psScriptRoot\Convert-AliasDefinition.ps1
. $psScriptRoot\convertall.ps1
. $psScriptRoot\ConvertFrom-Alias.ps1
. $psScriptRoot\Sign-ISEScript.ps1
. $psScriptRoot\Print-ISEFile.ps1

#create a custom sub menu
$jdhit=$psise.CurrentPowerShellTab.AddOnsMenu.Submenus.Add("ISE Scripting Geek",$null,$null)

#add my menu addons
$jdhit.submenus.Add("Add Help",{New-CommentHelp},$null) | Out-Null
$jdhit.submenus.Add("Convert to text file",{ConvertTo-TextFile}, $null) | out-null
$jdhit.submenus.Add("Convert All Aliases",{ConvertTo-Definition $psise.CurrentFile.Editor.SelectedText},$Null) | Out-Null
$jdhit.submenus.Add("Convert From Alias",{ConvertFrom-Alias},$Null) | Out-Null
$jdhit.submenus.Add("Convert Selected to Alias",{Convert-AliasDefinition $psise.CurrentFile.Editor.SelectedText -ToAlias},$Null) | Out-Null
$jdhit.submenus.Add("Convert Selected to Command",{Convert-AliasDefinition $psise.CurrentFile.Editor.SelectedText -ToDefinition},$Null) | Out-Null
$jdhit.submenus.Add("Insert Datetime",{$psise.CurrentFile.Editor.InsertText(("{0} {1}" -f (get-date),(get-wmiobject win32_timezone -property StandardName).standardName))},$null) | out-Null
$jdhit.submenus.Add("Open Current Script Folder",{Invoke-Item (split-path $psise.CurrentFile.fullpath)},$null) | out-Null
$jdhit.submenus.Add("Print Script",{Send-ToPrinter},$null) | Out-Null
$jdhit.submenus.Add("Save File as ASCII",{$psISE.CurrentFile.Save([Text.Encoding]::ASCII)}, $null) | out-null
$jdhit.submenus.Add("Sign Script",{Write-Signature},$null) | Out-Null
$jdhit.Submenus.Add("Test Buffer",{Test-Buffer}, $null) | out-Null

#setup most recent list
. $psscriptroot\Set-ISEMostRecent.ps1 -count 10 | Out-Null

Export-ModuleMember -Function *