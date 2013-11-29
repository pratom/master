$error.clear();
Set-StrictMode -Version:Latest
$GLOBAL:ErrorActionPreference               = "Stop"

."$PSCommandPath.vars.ps1"

."$SCRIPT:DIRECTORY_PATH_OF_pratom_ATOM_NUCLEUS_PROTONS_FILE_SYSTEM\get_child_directories.ps1"
."$SCRIPT:DIRECTORY_PATH_OF_pratom_ATOM_NUCLEUS_PROTONS_FILE_SYSTEM\get_child_files.ps1"
."$SCRIPT:DIRECTORY_PATH_OF_pratom_ATOM_NUCLEUS_PROTONS_FILE_SYSTEM\files_batch_rename.ps1"
."$SCRIPT:DIRECTORY_PATH_OF_pratom_ATOM_NUCLEUS_PROTONS_FILE_SYSTEM_PATH\path.ps1"



<# Assert that some of the basic functions work ================================================= #>
    $path_type = ( path_data_type $PSScriptRoot ).Name
    if ( $path_type -ne 'DirectoryInfo') { throw "path_data_type is broken.  It says the known path of [$PSScriptRoot] is of type [$path_type]."}
    if (( path_is_to_directory $PSScriptRoot) -ne $true) { throw "path_is_to_directory is broken.  It says that the known path of [$PSScriptRoot] is not a path." }
    if (( path_is_to_file $PSCommandPath ) -ne $true) { throw "path_is_to_file is broken.  It says that the known file of [$PSCommandPath] is not a file." }
<# Assert that some of the basic functions work ================================================= #>