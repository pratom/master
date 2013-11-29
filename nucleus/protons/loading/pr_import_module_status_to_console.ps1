
<#
.SYNOPSIS
    http://social.technet.microsoft.com/Forums/scriptcenter/en-US/e961e00d-e2aa-4d42-baa5-fb2fa50f4fc0/controlling-powershells-console-output
#>

$SCRIPT:pr_import_module_status_last_directory = ""
$SCRIPT:pr_import_module_status_first_directory = ""
$SCRIPT:pr_import_module_status_indent_right = 50
Function pr_import_module_status_to_console
{
    [cmdletbinding()] Param ( [Parameter(Mandatory=$True)]$file_path_and_name ) 
    $file_path_and_name = $file_path_and_name.Replace("\\", "\")
    $just_file = (Split-Path -Path:$file_path_and_name -Leaf)
    $directory = (Split-Path -Path:$file_path_and_name )

    pr_import_module_status_set_first_dirs -directory:$directory

    if ( $directory -ne $SCRIPT:pr_import_module_status_last_directory )
        {
            $SCRIPT:pr_import_module_status_last_directory = $directory
            $dir_line = pr_import_module_status_get_dir_line -directory:$directory
            write-host -NoNewline -Object:"$($dir_line)------> $just_file"
        }
    else 
        {
            write-host -NoNewline -Object:", $just_file"
        }
}


Function pr_import_module_status_get_dir_line
{
    [cmdletbinding()] Param ( [Parameter(Mandatory=$True)]$directory)
    assert_caller_is_in_my_file
    $dir_line = $directory.Replace($SCRIPT:pr_import_module_status_first_directory, " .")
    $dir_line = "$($nl)--> $dir_line"
    if ( $dir_line.Length -ge $SCRIPT:pr_import_module_status_indent_right ) { $SCRIPT:pr_import_module_status_indent_right  = ( $dir_line.Length + 10 ) }
    $dir_line = $dir_line.PadRight($SCRIPT:pr_import_module_status_indent_right, " ")
    return $dir_line
}


Function pr_import_module_status_set_first_dirs
{
    [cmdletbinding()] Param ( [Parameter(Mandatory=$True)]$directory)
    assert_caller_is_in_my_file
    if ( $SCRIPT:pr_import_module_status_first_directory -eq "" )
    { 
        pr_import_module_status_set_first_directory $directory
    }
    else 
    {
        $in_common = (directory_find_common_path $SCRIPT:pr_import_module_status_first_directory $directory)
        if ( $in_common -ne $SCRIPT:pr_import_module_status_first_directory )
        {
            if ( $in_common -eq $null )
                {
                    pr_import_module_status_set_first_directory $directory   
                }
            else 
                {
                    pr_import_module_status_set_first_directory $in_common     
                }
        } 
    }

    if ( $SCRIPT:pr_import_module_status_last_directory -eq "" )
    {
        $SCRIPT:pr_import_module_status_last_directory = " "
    }
    return $null
}


Function pr_import_module_status_set_first_directory
{
    [cmdletbinding()] Param ( [Parameter(Mandatory=$True)]$directory)
    assert_caller_is_in_my_file
    $SCRIPT:pr_import_module_status_first_directory = $directory 
    write-host -NoNewline -Object:"$($nl)$SCRIPT:pr_import_module_status_first_directory" 
}

<#
.SYNOPSIS

.EXAMPLE
    $dir_1 = "C:\projects\ready_bake\pratom\lib\computer"
    $dir_2 = "C:\projects\ready_bake\pratom\lib\computer"
    $common = directory_find_common_path $dir_1 $dir_2
    write-host $common

.EXAMPLE
    $dir_1 = "C:\projects\ready_bake\pratom\lib"
    $dir_2 = "C:\projects\ready_bake\pratom\lib\computer"
    $common = directory_find_common_path $dir_1 $dir_2
    write-host $common

.EXAMPLE
    $dir_1 = "C:\projects\ready_bake\pratom\lib\computer"
    $dir_2 = "C:\projects\ready_bake\pratom\lib"
    $common = directory_find_common_path $dir_1 $dir_2
    write-host $common

.EXAMPLE
    $dir_1 = "C:\projects\"
    $dir_2 = "C:\projects\ready_bake\pratom\lib"
    $common = directory_find_common_path $dir_1 $dir_2
    write-host $common

.EXAMPLE
    $dir_1 = "C:\projects\ready_bake\pratom\lib\computer"
    $dir_2 = "C:\projects\"
    $common = (directory_find_common_path $dir_1 $dir_2)
    write-host $common

.EXAMPLE
    $dir_1 = "C:\projects\ready_bake\pratom\lib\computer"
    $dir_2 = "C:\projects"
    $common = (directory_find_common_path $dir_1 $dir_2)
    write-host $common

.EXAMPLE
    $dir_1 = "C:\"
    $dir_2 = "C:\"
    $common = (directory_find_common_path $dir_1 $dir_2)
    write-host $common

#>
Function directory_find_common_path
{
    [cmdletbinding()] Param ( 
        [Parameter(Mandatory=$True)]            $directory_1
        , [Parameter(Mandatory=$True)]          $directory_2
        ) 
    $directory_1          = $directory_1.Replace("\\", "\")
    $directory_2          = $directory_2.Replace("\\", "\")

    $directory_1_unwound = (directory_unwound -unwind_dir:$directory_1 )
    $directory_2_unwound = (directory_unwound -unwind_dir:$directory_2 )

    $directory_1_root = ""

    [string]$in_common = $null
    $directory_1_unwound.GetEnumerator() | Sort-Object Name -descending | ForEach-Object { 
        write-debug "TOP of dir1 loop.  dir1 root=[$directory_1_root]."
        $directory_1_root = $_.Value
        if ( $directory_2_unwound.Values.Contains($directory_1_root) -eq $true )  
        {
            $in_common = $directory_1_root    
        }
        else 
        {
            write-debug "dir2 unwound does not contain $directory_1_root"
        }
        write-debug "BOTTOM of dir1 loop.  dir1 root=[$directory_1_root]."
    }
    if ($DebugPreference -eq "Continue")
    {
        write-debug "BEGIN directory_2_unwound"
        $directory_2_unwound.GetEnumerator() | Sort-Object Name -descending | ForEach-Object { write-debug "$($_.Value)" }
        write-debug "END directory_2_unwound"
    }
    write-debug "Exiting function   incommon = $in_common"
    return $in_common
}


<#
.SYNOPSIS
    breaks a path down into descending steps

    Name is for sorting upon.

    Can't believe I couldn't find this somewhere else, but I didn't
.EXAMPLE
    $dir = "C:\projects\ready_bake\pratom\lib\computer"
    $hsh = directory_unwound $dir
    $hsh | Format-Table
    Name                           Value                                                                                                                                                                                                                             
    ----                           -----  
    0                              C:\projects\ready_bake\pratom\lib\computer  
    1                              C:\projects\ready_bake\pratom\lib  
    2                              C:\projects\ready_bake\pratom    
    3                              C:\projects\ready_bake  
    4                              C:\projects    
    5                              C:\     

.EXAMPLE
    $dir = "C:\projects\"
    $hsh = directory_unwound $dir
    $hsh | Format-Table
#>
Function directory_unwound
{
    [cmdletbinding()] Param (  [Parameter(Mandatory=$True)] $unwind_dir )  
    $index = 0  
    $ret_hash = @{"0"=$unwind_dir}
    while ( $unwind_dir.Length -gt 0 ) {
        $index += 1
        $unwind_dir = (Split-Path -Parent -Path:$unwind_dir )
        if ( $unwind_dir -ne "" )
        {
            $ret_hash.Add($index, $unwind_dir)
        }
    }
    return $ret_hash
}




