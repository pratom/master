[hashtable]$SCRIPT:vm_cached_credentials_hash = @{};
Function VM_get_cached_credentials ( $machine_fqdn )
{
    $ret_credentials = $null
    if ($SCRIPT:vm_cached_credentials_hash.contains($machine_fqdn) -eq $true)
    {
        $ret_credentials =  ($SCRIPT:vm_cached_credentials[$machine_fqdn])
    }
    else 
    {
        if ( $machine_fqdn -eq "NG-v11-WEB-RB2" )
        {
            $secpasswd = ( ConvertTo-SecureString "Abc123!" -AsPlainText -Force )
            $ret_credentials = ( New-Object System.Management.Automation.PSCredential ("ngAdmin", $secpasswd) )
        }
        else 
        {
            $ret_credentials = ( VM_credentials_get_from_user -related_machine_name:$machine_fqdn -function_related_prompt:"For credentials caching" )
        }
        ($SCRIPT:vm_cached_credentials_hash).Add( $machine_fqdn, $ret_credentials) 
    }
    return $ret_credentials
}