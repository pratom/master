

<#
.SYNOPSIS
    http://www.vnoob.com/2012/10/changing-vm-ip-addresses-with-powercli/


#>
Function change_vm_ip_address
{
    Get-VMGuestNetworkInterface testcr -GuestCredential (Get-Credential) |
    Where-Object { $_.ip -ne $null} |
    Set-vmguestnetworkinterface -ip “10.22.15.168″ -netmask “255.255.255.0″ -gateway “10.22.15.1″ -GuestCredential (Get-Credential)
}

Function change_vm_ip_address
{
    $guest_credentials = (VM_get_cached_credentials -machine_fqdn:"NG-v11-RDS-RB")

    Get-VMGuestNetworkInterface testcr -GuestCredential: $guest_credentials |
    Where-Object { $_.ip -ne $null} |
    Set-vmguestnetworkinterface -ip “10.22.15.168″ -netmask “255.255.255.0″ -gateway “10.22.15.1″ -GuestCredential (Get-Credential)
}



<#
.SYNOPSIS
    http://www.jasemccarty.com/blog/?p=792
        * Set-VMGuestNetworkInterface does not work in my environment if the vNic is disconnected.
        * I could not use the vSphere PowerCLI in x64 mode to run the script.  The PowerCLI stated that I needed to use the 32bit PowerCLI instead.
        * WINS settings are not available in Linux guests

#>
Function change_vm_ip_address_2
    {
        Connect-VIServer vcenter.jasemccarty.com

        $HostCred = $Host.UI.PromptForCredential(&quot;Please enter credentials&quot;, &quot;Enter ESX host credentials&quot;, &quot;&quot;, &quot;&quot;)
        $GuestCred = $Host.UI.PromptForCredential(&quot;Please enter credentials&quot;, &quot;Enter Guest credentials&quot;, &quot;&quot;, &quot;&quot;)

        $vmlist = Import-CSV C:vms.csv

        foreach ($item in $vmlist) 
            {

                # I like to map out my variables
                $vmname = $item.vmname
                $ipaddr = $item.ipaddress
                $subnet = $item.subnet
                $gateway = $item.gateway
                $pdnswins = $item.pdnswins
                $sdnswins = $item.sdnswins

                #Get the current interface info
                $GuestInterface = Get-VMGuestNetworkInterface -VM $vmname -HostCredential $HostCred -GuestCredential $GuestCred

                #If the IP in the VM matches, then I don't need to update
                If ($ipaddr -ne $($GuestInterface.ip)) 
                    {
                        Set-VMGuestNetworkInterface  -VMGuestNetworkInterface $GuestInterface -HostCredential $HostCred -GuestCredential $GuestCred -IP $ipaddr -Netmask $subnet -Gateway $gateway -DNS $pdnswins,$sdnswins -WINS $pdnswins,$sdnswins
                    }

                $adapter = $item.NetworkAdapter
                If ($adapter -eq $(“Network adapter 1″)) 
                    {
                        Set-VMGuestNetworkInterface -VMGuestNetworkInterface $GuestInterface -HostCredential $HostCred -GuestCredential $GuestCred -IP $ipaddr -Netmask $subnet -Gateway $gateway -DNS $pdnswins,$sdnswins -WINS $pdnswins,$sdnswins
                    }
                If ($adapter -eq $(“Network adapter 2″)) 
                    {
                        Set-VMGuestNetworkInterface -VMGuestNetworkInterface $GuestInterface -HostCredential $HostCred -GuestCredential $GuestCred -IP $ipaddr -Netmask $subnet -Gateway $gateway -DNS $pdnswins,$sdnswins -WINS $pdnswins,$sdnswins
                    }
            }
    }