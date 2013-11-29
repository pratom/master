<#
.SYNOPSIS
    Calling this resets the base name, which then means all logs derived from it have their names changed as well.
#>
Function generate_a_new_log_file_name
{
    [cmdletbinding()] Param ()
    $new_base_name = (pratom_PATH_LOG_FILE_NAME_TEMPLATE).Replace("{sortable_date}", (get_sortable_date))  
    $SCRIPT:pratom_log_name_base = $new_base_name
}