
#TODO: When in development mode, DO load files named "*.Tests.*".  When in Production, DO NOT 
function pr_import_module
{
    [cmdletbinding()] Param ( [Parameter(Mandatory=$True)]$file_path_and_name,  [Parameter(Mandatory=$False)] $param_string="")
    assert_caller_is_in_my_directory  
    pr_import_module_status -file_path_and_name:$file_path_and_name  
    $SCRIPT:pr_import_module_files["pr_import_module_count"] += 1
    [string]$ret_string = "
import-module -NoClobber $(pr_setting_add_verbose_flag_to_import_module) -DisableNameChecking -Name:'$file_path_and_name' $param_string ;"
    return($ret_string)
}


function pr_setting_add_verbose_flag_to_import_module
{
    [cmdletbinding()] Param ( )    
    $ret_string = ""
    if ((pr_settings_get_boolean) -eq $true )
    {
        $ret_string = "-VERBOSE"
    }
    return $ret_string
}


function pr_setting_debug_writes_code_to_load
{
    return pr_settings_get_boolean
}


function pr_setting_import_module_call_count
{
    [cmdletbinding()] Param ( [Parameter(Mandatory=$True)][string] $module_name )   
    $hash_table = pr_settings_get_hashtable

    [int]$ret_int = 0
    if ($hash_table.Contains($module_name))
    {
     $ret_int =  $hash_table[$module_name]  
    }
    return $ret_int
}


Function pr_setting_import_module_status_show_per_file
{
    [cmdletbinding()] Param ( [Parameter(Mandatory=$true)]             [string]$calling_file )
    [HashTable]$settings_hash = pr_settings_get_hashtable
    $ret_val = $settings_hash[$calling_file]
    return ( $ret_val )
}

Function pr_setting_import_module_status_show_to_console
{
    return pr_settings_get_boolean
}