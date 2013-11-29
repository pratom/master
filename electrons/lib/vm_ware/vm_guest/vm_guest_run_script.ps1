Function vm_guest_run_script
{

    [cmdletbinding()] 
    Param ( 
          [Parameter(Mandatory=$true)][string]              $guest_fqdn 
        , [Parameter(Mandatory=$true)][PSCredential]        $guest_ps_credentials 
        , [Parameter(Mandatory=$true)][string]              $script 
        )

    <#
        Invoke-VMScript : 11/18/2013 1:10:41 PM    Invoke-VMScript        Object reference not set to an instance of an object.    
        At C:\projects\ready_bake\pratom\lib\vm_ware\simple_ip_change_for_stoker.ps1:209 char:13
        +     $ans = (Invoke-VMScript -ScriptType:Bash -ScriptText:$script -VM:$guest_fqdn ...
        + ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            + CategoryInfo          : NotSpecified: (:) [Invoke-VMScript], ViError
            + FullyQualifiedErrorId : Client20_ClientSideTaskImpl_ThreadProc_UnhandledException,VMware.VimAutomation.ViCore.Cmdlets.Commands.InvokeVmScript
    #>



    $host_os                = ""
    $host_ps_credentials    = ( VM_get_cached_credentials -machine_fqdn:$host_os )
    $ans = ( Connect-VIServer -Server:$host_os -Credential:$host_ps_credentials -verbose )
    write-host "$ans"

    write-host "`$guest_fqdn=[$guest_fqdn].   `$guest_ps_credentials=[$guest_ps_credentials].   `$script=[$script]"
    $err=$null
    $warn=$null
    # -GuestCredential:$guest_ps_credentials 
    $ans = (Invoke-VMScript -GuestUser:ngAdmin -GuestPassword:Abc123! -ScriptType:Bash -ScriptText:$script -VM:$guest_fqdn -Confirm:$false -ErrorAction:"Stop"    )
    write-host "$err"
    write-host "$warn"
    write-host "Invoke vm script answer = [$ans]"
}