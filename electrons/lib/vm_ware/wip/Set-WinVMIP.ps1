<#
.SYNOPSIS
    http://www.virtu-al.net/2010/02/05/powercli-changing-a-vm-ip-address-with-invoke-vmscript/

.EXAMPLE
    Connect-VIServer MYvCenter

    $VM = Get-VM ( Read-Host "Enter VM name" )
    $ESXHost = $VM | Get-VMHost
    $HostCred = $Host.UI.PromptForCredential("Please enter credentials", "Enter ESX host credentials for $ESXHost", "root", "")
    $GuestCred = $Host.UI.PromptForCredential("Please enter credentials", "Enter Guest credentials for $VM", "", "")
    $IP = "192.168.0.81"
    $SNM = "255.255.255.0"
    $GW = "192.168.0.1"

    Set-WinVMIP $VM $HostCred $GuestCred $IP $SNM $GW
#>

Function Set-WinVMIP ($VM, $HC, $GC, $IP, $SNM, $GW){
 $netsh = "c:\windows\system32\netsh.exe interface ip set address ""Local Area Connection"" static $IP $SNM $GW 1"
 Write-Host "Setting IP address for $VM..."
 Invoke-VMScript -VM $VM -HostCredential $HC -GuestCredential $GC -ScriptType bat -ScriptText $netsh
 Write-Host "Setting IP address completed."
}

 


