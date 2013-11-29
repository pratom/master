<#
.SYNOPSIS
    The load method includes the named Ruby source file every time the method is executed

    ALWAYS NoClobber... Why?  Because that way, it is more likely that YOUR code will fail, then someone else's code.
    YOUR code failing means that the problem happens QUICKLY.  THEIR code failing means.....It won't fail until waaay later, maybe after shipping.    
#>
function pr_everytime
{
    [cmdletbinding()]
    Param ( [Parameter(Mandatory=$True)]$file_path_and_name )
    assert_caller_is_in_my_directory 
    $SCRIPT:pr_import_module_files["pr_everytime"] += $file_path_and_name
    return (pr_import_module -file_path_and_name:$file_path_and_name -param_string:"-Force")
}