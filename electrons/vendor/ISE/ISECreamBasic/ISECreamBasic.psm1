$mInfo = $MyInvocation.MyCommand.ScriptBlock.Module
$mInfo.OnRemove = {
    Write-Host "$($MyInvocation.MyCommand.ScriptBlock.Module.name) removed on $(Get-Date)"
}

. $psScriptRoot\Add-IseMenu.ps1
. $psScriptRoot\Remove-IseMenu.ps1
. $psScriptRoot\demonstrate_isecreambasic.ps1

Export-ModuleMember -function *