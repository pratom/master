<#
.SYNOPSIS
    http://ict-freak.nl/2010/01/20/update-linux-vms-with-powercli-thanks-to-invoke-vmscript/

.EXAMPLE
    $hc = Get-Credential            $hc will save the Host Credentials. These are the credentials you need to authenticate with the ESX Host
    $gc = Get-Credential            $gc will save the Guest Credentials. These are the credentials you need to authenticate with the Linux Guest OS.
    $ifconfig = ""                  $ifconfig can be used to set a temporary ip address. Example: ifconfig eth0 192.168.123.166 netmask 255.255.255.0
    $route = ""                     $route can be used to set a temporary gateway address: route add default gw 192.168.123.254
#>

Function Update-LinuxVM{
 param($virtualmachine)
 $vm = Get-VM $virtualmachine
 assert_vm_is_running $vm 

 $os = (Get-VM $vm | Get-View).Summary.Config.GuestFullName
 $toolsStatus = (Get-VM $vm | Get-View).Guest.ToolsStatus
 if($vm.powerstate -eq "PoweredOn"){
    if($toolsStatus -eq "toolsOk"){
        # Determining Linux Distro
        if($os -match 'Red Hat Enterprise Linux'){
            Write-Host "RedHat or CentOS installation found" -fore Yellow 
            $update = "yum clean all && yum update -y"
        }
        elseif($os -match 'Debian GNU'){
            Write-Host "Debian installation found" 
            $update = "apt-get update && apt-get upgrade -y"
        }    
        else{Write-Host "No update possible" -fore Red}
        
        # ifconfig
        if($ifconfig -ne ""){
        Write-Host "Configuring IP settings $ifconfig" -fore Yellow
        $vm | Invoke-VMScript -HostCredential $hc -GuestCredential $gc $ifconfig
        }

        # route
        if($route -ne ""){
        Write-Host "Setting default gateway route $route" -fore Yellow
        $vm | Invoke-VMScript -HostCredential $hc -GuestCredential $gc $route
        }
        
        # Update command
        Write-Host "Running $update command" -fore Yellow
        $vm | Invoke-VMScript -HostCredential $hc -GuestCredential $gc $update
        }
        else{Write-Host $vm "VMware Tools are out off date or not running" -fore Red }
    }
 else{Write-Host $vm "is not running" -fore Red }
}