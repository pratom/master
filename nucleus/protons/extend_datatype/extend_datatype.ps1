<#   
.EXAMPLE
    extend_datatype_with_method -member_name:$member_name -script_block_get:$script_block_get -type_name:System.DateTime
#>
Function extend_datatype_with_method
{
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory=$True)]$member_name
        , [Parameter(Mandatory=$True)]$script_block_get
        , [Parameter(Mandatory=$True)]$type_name
    )
    $member_type="ScriptMethod"
    Write-Debug "extending [$type_name] with [$member_name]"
    Update-TypeData -TypeName:$type_name -MemberName:$member_name -Force -MemberType:$member_type -Value:$script_block_get   
    return $true
}


Function extend_datatype_with_property
{
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory=$True)]$member_name
        , [Parameter(Mandatory=$True)]$script_block_get
        , [Parameter(Mandatory=$True)]$type_name
    )
    $member_type="ScriptProperty"
    Write-Debug "extending [$type_name] with [$member_name]"
    Update-TypeData -TypeName:$type_name -MemberName:$member_name -Force -MemberType:$member_type -Value:$script_block_get   
    return $true
}

."$($SCRIPT:DIRECTORY_PATH_OF_pratom_ATOM_NUCLEUS_PROTONS)\extend_datatype\System.Object.ps1"
."$($SCRIPT:DIRECTORY_PATH_OF_pratom_ATOM_NUCLEUS_PROTONS)\extend_datatype\System.Collections.Hashtable.ps1"
."$($SCRIPT:DIRECTORY_PATH_OF_pratom_ATOM_NUCLEUS_PROTONS)\extend_datatype\System.Datetime.ps1"
."$($SCRIPT:DIRECTORY_PATH_OF_pratom_ATOM_NUCLEUS_PROTONS)\extend_datatype\System.String.ps1"