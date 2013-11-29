Function vm_host_connect ($VM_host_server_fqdn, $ps_credential)
{
    $ans = ( Connect-VIServer -Server:$VM_host_server_fqdn -Credential:$ps_credential -verbose )
    write-host "Connect to server answered = [$ans]"
}