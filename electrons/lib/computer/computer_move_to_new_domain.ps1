
Function computer_move_to_new_domain
{
    [cmdletbinding()] 
    Param ( 
            [Parameter(Mandatory=$True)]        [string]                            $domain 
            , [Parameter(Mandatory=$True)]      [string]                            $user 
            , [Parameter(Mandatory=$True)]      [System.Security.SecureString]      $password
            )

    $username = "$domain\$user"
    $credential = New-Object System.Management.Automation.PSCredential($username,$password) 

    try {
        Add-Computer -DomainName $domain -Credential $credential   
    }
    catch [Exception]{
        $msg = $error[0].Exception.message
        if ( $msg -like "Add-Computer : Failed to unjoin computer*with the following error message: Access is denied.")
            {
                throw "The computer must first be unjoined from its current domain, $(Get-Content env:UserDNSDomain).
                This script does not unjoin a computer."
            }
    }
}

Function UI_computer_move_to_new_domain
{
    $domain = Read-Host -Prompt "We are going to add this computer to a domain.
    We will need :
    * the name of the domain
    * An account which has the rights to add a computer to the domain:
    ** that account's username
    ** that account's password.

    Enter the domain name:"

    $user = Read-Host -Prompt "Enter the user name:"
    $password = Read-Host -Prompt "Enter password for $user of $domain :" -AsSecureString 

    computer_move_to_new_domain -domain:$domain -user:$user -password:$password
}
