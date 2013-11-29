#Write-Host [[-Object] <Object>] [-NoNewline] [-Separator <Object>] [-ForegroundColor <ConsoleColor>] [-BackgroundColor <ConsoleColor>] [<CommonParameters>]
Function Write-Host 
{
    [cmdletbinding()] Param ( 
        [Parameter(Mandatory=$false)]    [Object]          $Object
        ,                               [switch]          $NoNewline
        , [Parameter(Mandatory=$false)] [Object]          $Separator
        , [Parameter(Mandatory=$false)] [ConsoleColor]    $ForegroundColor 
        , [Parameter(Mandatory=$false)] [ConsoleColor]    $BackgroundColor
        ) 
    if ($NoNewline -eq $null) {$NoNewline=$false} 
    if ($Separator -eq $null) {$Separator=''}  
    if (($ForegroundColor -eq -1) -or ($ForegroundColor -eq $null)) {$ForegroundColor = "green"}
    if (($BackgroundColor -eq -1) -or ($BackgroundColor -eq $null)) {$BackgroundColor = "black"}
    try {
        $var = (Snif-WriteVerb -the_write_verbs_bound_parameters:$PSBoundParameters  -write_noun:"HOST" )    
    }
    catch [Exception]{
        Microsoft.PowerShell.Utility\Write-Warning "ERROR in sniffing verb.  [$($_.Exception.Message)] [$($_.InvocationInfo.PositionMessage)] [$($_.Exception.StackTrace)]"
    }
    
    return ( Microsoft.PowerShell.Utility\Write-Host -Object:$Object -NoNewline:$NoNewline -Separator:$Separator -ForegroundColor:$ForegroundColor -BackgroundColor:$BackgroundColor )
}