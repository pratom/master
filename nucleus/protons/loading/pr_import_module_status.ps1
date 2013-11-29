$SCRIPT:pr_import_module_files = @{};
$SCRIPT:pr_import_module_files["pr_import_module_count"] = 0;
$SCRIPT:pr_import_module_files["code_to_load_a_file"] = @();
$SCRIPT:pr_import_module_files["code_to_load_a_file"] = @();
$SCRIPT:pr_import_module_files["pr_import_module_count_per_module"] = @{};
$SCRIPT:pr_import_module_files["pr_import_module_count_per_file"] = @{};
$SCRIPT:pr_import_module_files["pr_import_module_count_per_command_name"] = @{};
$SCRIPT:pr_import_module_files["pr_import_module_count_per_function_name"] = @{};


$SCRIPT:pr_import_module_status_period_cntr = 0
function pr_import_module_status
{
    [cmdletbinding()] Param ( [Parameter(Mandatory=$True)]$file_path_and_name ) 
    assert_caller_is_in_my_directory   
    if ( pr_setting_import_module_status_show_to_console ) 
        { 
            pr_import_module_status_to_console -file_path_and_name:$file_path_and_name 
        }
    else 
        {
            if ( $SCRIPT:pr_import_module_status_period_cntr -ge 10 )
                {
                    $SCRIPT:pr_import_module_status_period_cntr = 0
                    write-host ""    
                }
            $SCRIPT:pr_import_module_status_period_cntr += 1
            write-host "." -nonewline
        }
    return $null
}

function pr_import_module_status_count_of_import_module_calls
{
    return $SCRIPT:pr_import_module_files["pr_import_module_count"]   
}

function pr_import_module_status_modules_loaded_as_once
{
    return $SCRIPT:pr_import_module_files["pr_once"]
}

function pr_import_module_status_modules_loaded_as_everytime
{
    return $SCRIPT:pr_import_module_files["pr_everytime"]   
}

function pr_import_module_status_count_of_import_module_calls_per_module
{
    return $SCRIPT:pr_import_module_files["pr_import_module_count_per_module"]    
}

function pr_import_module_status_count_of_import_module_calls_per_command_name
{
    return $SCRIPT:pr_import_module_files["pr_import_module_count_per_command_name"]    
}

function pr_import_module_status_count_of_import_module_calls_per_file
{
    return $SCRIPT:pr_import_module_files["pr_import_module_count_per_file"]   
}

function pr_import_module_status_count_of_import_module_calls_per_function_name
{
    $SCRIPT:pr_import_module_files["pr_import_module_count_per_function_name"]  
}