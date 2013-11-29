
<#
.SYNOPSIS
    Add-PSSnapin of VMware.VimAutomation.Core, when called from a module, blows up at a second attempt to load the module.
    The blow up is an error in the PowerCli code.
    One can not ( to my knowledge )code a way around it.  
    It appears that PowerCLI maintains its state in ways :
        * that are different from other Powershell code
        * that I do not understand
    The solution appears to be :=> have the calling application run the code.
    In order to reduce repeated code, I chose this method, making the block of code available.
    This method appears to work very well.
.EXAMPLE
$code_to_run = vm_code_to_load_vm_once_per_session_only_outside_of_pratom
Invoke-Expression $code_to_run
          Welcome to the VMware vSphere PowerCLI!

Log in to a vCenter Server or ESX host:              Connect-VIServer
To find out what commands are available, type:       Get-VICommand
To show searchable help for all PowerCLI commands:   Get-PowerCLIHelp
Once you've connected, display all virtual machines: Get-VM
If you need more help, visit the PowerCLI community: Get-PowerCLICommunity

       Copyright (C) 1998-2013 VMware, Inc. All rights reserved.    
#>
Function vm_code_to_load_vm_once_per_session_only_outside_of_pratom
{

$ret_code = @'

Add-PSSnapin VMware.VimAutomation.Core 
Add-PSSnapin VMware.VumAutomation           # VMWare Update Manager

$vm_ware_power_cli_install_dir = [Environment]::GetEnvironmentVariable("ProgramFiles(x86)")
. "$vm_ware_power_cli_install_dir\VMware\Infrastructure\vSphere PowerCLI\Scripts\Initialize-PowerCLIEnvironment.ps1" 

'@
return $ret_code

}
