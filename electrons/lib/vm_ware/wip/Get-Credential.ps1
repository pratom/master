<#
.SYNOPSIS
    Since this library is embedded in a an otherwise UI / Prompt free library, mask Get-Credential so that we don't accidentally stop any processing
    Of course, the script will not work, but at least it won't get stuck infinitly somewhere.

    TODO:  If you learn how to detect the presence of a user, call the real Get-Credential from here.
    TODO:  Can change to check if caller fits our naming standard : UI_something.  If it does, then pass through the call.  If it does not, warning and return $null.
Function Get-Credential
{
    Write-Warning "Get-Credential was called.  It has been masked to prevent an infinite hang in a script which is not running in front of a user."
    return $null 
}

#>