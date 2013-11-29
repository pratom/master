<#
pr_include (code_to_load_a_file "$(Split-Path $PSCommandPath)\settings_console_colors.ps1" )
pr_include (code_to_load_a_file "$(RAILS_PATH_CORE)\lib\extend_datatype\extend_datatype.ps1" )

# change the bland before the vivid colors.  If the host supports vivid colors, the bland will be overwritten.
(Get-Host).UI.RawUI.ForeGroundColor = $SCRIPT:console_properties.ConsolePaneForegroundColor_bland
(Get-Host).UI.RawUI.BackgroundColor = $SCRIPT:console_properties.ConsolePaneBackgroundColor_bland

$a = (Get-Host).PrivateData;
if (( Set_Properties_From_Hash ([ref]$a) -property_hash:$SCRIPT:console_properties ) -ne $true )
{
    write-error "Failed to set properties"
}
#>
<#
DefaultOptions                            Property     Microsoft.PowerShell.Host.ISE.ISEOptions DefaultOptions {get;} 

TODO: Token Colors - especially Console.  Right now, we are leaving them in a weird state that is not usable in a new prompt w/o calling rails.
ConsoleTokenColors                        Property     System.Collections.Generic.IDictionary[System.Management.Automation.PSTokenType,System.Windows.Media.Color] ConsoleTokenColors {get;}
TokenColors                               Property     System.Collections.Generic.IDictionary[System.Management.Automation.PSTokenType,System.Windows.Media.Color] TokenColors {get;}       
XmlTokenColors                            Property     System.Collections.Generic.IDictionary[Microsoft.PowerShell.Host.ISE.PSXmlTokenType,System.Windows.Media.Color] XmlTokenColors {get;}

SelectedScriptPaneState                   Property     Microsoft.PowerShell.Host.ISE.SelectedScriptPaneState SelectedScriptPaneState {get;set;}              
AutoSaveMinuteInterval                    Property     int16 AutoSaveMinuteInterval {get;set;}  
Zoom                                      Property     double Zoom {get;set;} 

$psise.Options.OutputPaneBackgroundColor  = "#FFF0F8FF"
$psise.Options.OutputPaneForegroundColor = "#FF000000"
$psise.Options.OutputPaneTextBackgroundColor = "#FFF0F8FF"

foreach ($key in ($psise.Options.ConsoleTokenColors.keys |%{$_.tostring()})) {
    $color = $psise.Options.TokenColors.Item($key)
    $newcolor = [System.Windows.Media.Color]::FromArgb($color.a,$color.r,$color.g,$color.b)
    $psise.Options.ConsoleTokenColors.Item($key) = $newcolor
}
#>

