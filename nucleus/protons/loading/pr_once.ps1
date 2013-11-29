<#
.SYNOPSIS
    require method loads any given file only once

    ALWAYS NoClobber... Why?  Because that way, it is more likely that YOUR code will fail, then someone else's code.
    YOUR code failing means that the problem happens QUICKLY.  THEIR code failing means.....It won't fail until waaay later, maybe after shipping.

    DONE_TODO: 2013.11.06.JLM : code_to_load_a_file : if in development mode, conditional code_to_load_a_file to always return code_to_load_a_file
    DONE_TODO: 2013.11.06.JLM : code_to_load_a_file / pr_once : change all references in code to code_to_load_a_file, unless there is a reason otherwise.
#>
function pr_once
{
    [cmdletbinding()] Param ( [Parameter(Mandatory=$True)]$file_path_and_name )
    assert_caller_is_in_my_directory 
    $SCRIPT:pr_import_module_files["code_to_load_a_file"] += $file_path_and_name
    return ( pr_import_module -file_path_and_name:$file_path_and_name )
}
