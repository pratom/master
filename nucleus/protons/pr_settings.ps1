
function pr_settings_get_value
{
    [cmdletbinding()] Param (  )
    assert_caller_is_in_my_file

    [string]$exterior_calling_function_name = (Get-PSCallStack)[2].Command
    [string]$setting_name           = (pr_settings_name $exterior_calling_function_name)
    [string]$code_file_who_called_us = ((Get-PSCallStack)[1].InvocationInfo).PSCommandPath
    [string]$callers_settings_file  = (pr_settings_file $code_file_who_called_us)
    $my_settings_hash               = (pr_settings_hash $callers_settings_file)

    $ret_value = $null
    If ( $my_settings_hash.Contains($setting_name) )
    {
        write-debug "[$PSCommandPath] - [$setting_name]=[$ret_value]." 
        return $my_settings_hash[$setting_name]  
    }
    else {
        throw "[$PSCommandPath] - the settings hash did not contain a value for the name=[$setting_name].  We were looking at the file=[$callers_settings_file]."
    } 
}


# TODO: pr_settings_get_value figure out if there is a more efficient way to do this...
function pr_settings_hash
{
    [cmdletbinding()] Param ( [Parameter(Mandatory=$true)]             [string]$callers_settings_file)  

    assert_caller_is_in_my_file
    if ( (Test-Path -LiteralPath:$callers_settings_file -PathType:Leaf) -eq $false )
    {
        throw "The settings file does not exist.  settings file=[$callers_settings_file]"  
    }
    import-module -NoClobber -Force -Name:$callers_settings_file     # this has declared the variable, [HashTable] $my_settings_hash

    if ((Test-Path variable:mysettings_hash) -eq $false )
    {
        throw "The settings file is required to contain a definition for a hash named `$mysettings_hash.  settings file=[$callers_settings_file]"
    }
    return $mysettings_hash
}


function pr_settings_name
{
    [cmdletbinding()]  Param ( [Parameter(Mandatory=$true)]             $exterior_calling_function_name ) 
    assert_caller_is_in_my_file 
    $required_function_pre = "pr_setting_"
    [string]$err_msg = "Settings are required to be looked up by a function named [$required_function_pre][{setting_name}].  The function that actually called was=[$exterior_calling_function_name]."
    if ( $exterior_calling_function_name.Length -le 11 ) { throw $err_msg }
    if ($exterior_calling_function_name.Substring(0,11) -ne "pr_setting_") { throw $err_msg }
    write-debug "pr_settings_name=[{$exterior_calling_function_name}]."
    return ($exterior_calling_function_name)
}


function pr_settings_file
{
    [cmdletbinding()]  Param ( [Parameter(Mandatory=$true)]             $code_file_who_called_us ) 
    assert_caller_is_in_my_file 
    [string]$settings_file_full_name = "$($code_file_who_called_us).settings.ps1"
    write-debug "pr_settings_file `$settings_file_full_name=[$settings_file_full_name]."
    return $settings_file_full_name
}


function pr_settings_get_boolean
{
    [cmdletbinding()] Param ( ) 
    $val = pr_settings_get_value
    [bool]$ret_bool = $false
    if (($val -eq 1) -or ($val -eq "true") -or ($val -eq "t") -or ($val -eq "on") -or ($val -eq 'y') -or ($val -eq 'yes'))
    { 
        $ret_bool = $true    
    } 
    return $ret_bool
}


function pr_settings_get_string
{
    [cmdletbinding()] Param ( ) 
    $val = pr_settings_get_value
    [string]$ret_string = $val    
    return $ret_string
}

function pr_settings_get_hashtable
{
    [cmdletbinding()] Param ( ) 
    $val = pr_settings_get_value
    [HashTable]$ret_val = $val    
    return $ret_val
}