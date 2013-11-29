$SCRIPT:sniffers=@{};
$SCRIPT:sniffing_is_occurring=$false;
Function Snif-WriteVerb
{
    [CmdletBinding()] 
    param( 
        [Parameter(Position=0, Mandatory = $true)]      [Object] $the_write_verbs_bound_parameters
        , [Parameter(Position=1, Mandatory = $true)]    [string] $write_noun 
        )
    Write-Safe-Debug "Snif-WriteVerb is beginning..."
    Set-StrictMode -Version:Latest
    try 
        {
            Write-Safe-Debug "Snif-WriteVerb is beginning... There are [$($SCRIPT:sniffers.Count)] sniffers to invoke."
            $sniffers_to_remove = @();
            if ( $SCRIPT:sniffing_is_occurring -eq $false )
                {
                    $SCRIPT:sniffing_is_occurring = $true
                    [string]$sniffer_name_now = ""
                    foreach ($sniffer in $SCRIPT:sniffers.GetEnumerator()) {
                        try {
                            $sniffer_name_now = $sniffer.name
                            $script_block=($sniffer.value)
                            Invoke-Command -NoNewScope -ScriptBlock:$script_block 
                        }
                        catch [Exception]{
                            Write-Safe-Warning "Snif-WriteVerb The sniffer,[$sniffer_name_now], threw an exception, [$($_.Exception.Message)] [$($_.Exception.StackTrace)]."
                            $sniffers_to_remove += $sniffer_name_now
                        }
                    }
                    Write-Safe-Debug "Snif-WriteVerb There are [$($sniffers_to_remove.Length)] sniffers to remove because they errord."
                    foreach($sniffer_name in $sniffers_to_remove)
                    {
                        Write-Safe-Warning "Snif-WriteVerb Removing the sniffer,[$sniffer_name], because it errored."
                        Remove-WriteSniffer  -our_name_for_your_sniffer:$sniffer_name  
                    }
                    $SCRIPT:sniffing_is_occurring = $false
                }
        }
    catch 
        {
            Write-Safe-Warning "Snif-WriteVerb in main body threw an exception.  Swallowing it. $($_.Exception.Message)."
        }
    Write-Safe-Debug "Snif-WriteVerb is ending..."
    return $null
}
 




<#
.SYNOPSIS
    See Add-WriteSniffer
    returns $true
#>
Function Remove-WriteSniffer
{
    [CmdletBinding()]  param( [Parameter(Mandatory = $true)]  [string] $our_name_for_your_sniffer )
    Write-Safe-Debug "Remove-WriteSniffer is removing the sniffer, [$sniffer_name]"
    if ( $SCRIPT:sniffers.Contains($our_name_for_your_sniffer) )
    {
        $SCRIPT:sniffers.Remove($our_name_for_your_sniffer)
    }
    return $true
}

<#
.SYNOPSIS
    Returns our name for your sniffer.  Save the result so that you can use it to call Remove-WriteSniffer later on.
    $your_script_block - Has available to it an object named, $the_write_verbs_bound_parameters, of type [object], which is really a [System.Management.Automation.PSBoundParametersDictionary].
    If your sniffer throws an exception up to us, it will be removed, it will be removed and no longer called.
    If your sniffer throws too many exceptions inside of itself, it will be removed and no longer called.
    If your sniffer takes too long to execute, it will be removed and no longer called.
    If your sniffer resets the $error variable, it will be removed and no longer called.
    If your code calls ANY write-verb, it will be removed.
#>
Function Add-WriteSniffer
{
    [CmdletBinding()] 
    param( 
        [Parameter(Mandatory = $true)]  [string]                                            $your_name
        , [Parameter(Mandatory = $true)]  [System.Management.Automation.ScriptBlock]        $your_script_block
        ) 
    $our_name = "$($your_name)_$(GET-RANDOM)"
    [bool]$ok_to_add = $true
    if ( $your_script_block.ToString().Contains("Write-") ) { $ok_to_add = $false }
    if ( $ok_to_add -eq $true ) {
        $SCRIPT:sniffers.Add($our_name, $your_script_block)
    }
    return $our_name  
}