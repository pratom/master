function Write-Safe-Debug ($var)
{
    Microsoft.PowerShell.Utility\Write-Debug $var
}

function Write-Safe-Host ($var)
{
    Microsoft.PowerShell.Utility\Write-Host $var
}

function Write-Safe-Error ($var)
{
    Microsoft.PowerShell.Utility\Write-Debug $var
    Microsoft.PowerShell.Utility\Write-Error $var
}

function Write-Safe-Warning ($var)
{
    Microsoft.PowerShell.Utility\Write-Warning $var
}