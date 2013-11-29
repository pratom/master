<#
.SYNOPSIS
    # http://poshoholic.com/2009/01/19/powershell-quick-tip-how-to-retrieve-the-current-line-number-and-file-name-in-your-powershell-script/

.EXAMPLE
    #--------------------------------------Who am i?
    __FILE__           
        => C:\projects\ready_bake\learning\CodeWho\Code_who.ps1
    __FUNCTION__       
        => demo_my_invocation
    __LINE__           
        => 34
#>


function Get-CurrentCodeLineNumber { 
    $MyInvocation.ScriptLineNumber 
}
New-Alias -Name __LINE__ -Value Get-CurrentLineNumber -Description:"Returns the current line number in a PowerShell script file."

function Get-CurrentCodeFileName { 
    $MyInvocation.ScriptName 
}
New-Alias -Name __FILE__ -Value Get-CurrentFileName -Description:"Returns the name of the current PowerShell script file."

function Get-CurrentCodeFunctionName{
    $MyInvocation.InvocationName     
}
New-Alias -Name __FUNCTION__ -Value Get-CurrentLineNumber -Description:"Returns the name of the current code block in a PowerShell script file."

function GetCurrentCodePretty{
    return GetCallerCodePretty -invocation:$MyInvocation
}

function GetCallerCodePretty{
    [cmdletbinding()] Param ( [Parameter(Mandatory=$True)]$invocation )
    return "[$($invocation.ScriptName )].[$($invocation.InvocationName)] Line=[$($invocation.ScriptLineNumber)]"
}

    