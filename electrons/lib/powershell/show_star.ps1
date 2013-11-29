<# 
.SYNOPSIS
    Only works in Windows Command
    Does NOT work in Powershell ISE
#>
$SCRIPT:star_parts = '|','/','-','\' 
function show_star
{
    pr_import_module_status_set_position
    $SCRIPT:star_parts | ForEach-Object { Write-Host -Object $_ -NoNewline
                Start-Sleep -Milliseconds 10
                [console]::setcursorposition($SCRIPT:import_status_to_console_saveX,$SCRIPT:import_status_to_console_saveY)         <#  it will not work in the PowerShell ISE. #>
                } # end foreach-object       
}